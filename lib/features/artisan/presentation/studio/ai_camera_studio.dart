import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

class AiCameraStudioScreen extends ConsumerStatefulWidget {
  const AiCameraStudioScreen({super.key});

  @override
  ConsumerState<AiCameraStudioScreen> createState() => _AiCameraStudioScreenState();
}

class _AiCameraStudioScreenState extends ConsumerState<AiCameraStudioScreen> {
  int _currentPhase = 1; // 1: Capture, 2: Enhance, 3: Voice/Catalog, 4: Pricing
  int _maxReachedPhase = 1;

  // Phase 1: Capture
  File? _capturedImage;
  Uint8List? _capturedImageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isTorchOn = false;

  // Phase 2: AI Enhance
  bool _isEnhancing = false;
  Uint8List? _enhancedBytes;
  int _enhanceStep = 0; // 0: Removing bg, 1: Lighting, 2: Done
  bool _showAfter = true;

  // Phase 3: Voice Cataloger
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  Timer? _recordTimer;
  int _recordSeconds = 0;
  String? _recordedAudioPath;
  bool _isCataloging = false;
  bool _isVisionAnalyzing = false;
  final _manualPromptController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _titleHiController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descHiController = TextEditingController();
  String _craftCategory = 'Textiles & Handloom';
  List<String> _tags = ['#HandmadeInIndia', '#VocalForLocal', '#MoSJE'];
  List<String> _materials = ['Natural Materials'];

  // Phase 4: Pricing Assistant
  double _materialCost = 450.0;
  double _manufacturingHours = 4.0;
  double _minPrice = 650.0;
  double _suggestedPrice = 1200.0;
  double _premiumPrice = 1800.0;
  double _selectedPrice = 1200.0;
  double _b2bPrice = 1020.0;
  double _marketAvg = 0.0;
  double _marketMin = 0.0;
  double _marketMax = 0.0;
  String _complexity = 'moderate';
  String _pricingNotes = 'Calculated using fair wage multiplier and raw material costs.';
  String? _competitorRange = '₹ 1,000 – ₹ 1,800';
  List<Map<String, dynamic>>? _shapTopFeatures;
  String? _mlEngineUsed;
  double? _fairWageFloor;
  bool _isCalculatingPricing = false;
  bool _isListing = false;

  // Pricing Inputs
  final _materialCostController = TextEditingController(text: '450');
  final _laborHoursController = TextEditingController(text: '4');
  String _materialTypeDropdownValue = 'Cotton';
  String _complexityDropdownValue = 'moderate';

  @override
  void dispose() {
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    _manualPromptController.dispose();
    _titleEnController.dispose();
    _titleHiController.dispose();
    _descEnController.dispose();
    _descHiController.dispose();
    _materialCostController.dispose();
    _laborHoursController.dispose();
    super.dispose();
  }

  // --- Phase 1 Handlers ---
  void _pickFromCamera() async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _capturedImageBytes = bytes;
        if (!kIsWeb) {
          try {
            _capturedImage = File(photo.path);
          } catch (_) {}
        }
        _currentPhase = 2;
        if (_maxReachedPhase < 2) _maxReachedPhase = 2;
      });
      _startEnhancement();
    }
  }

  void _pickFromGallery() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _capturedImageBytes = bytes;
        if (!kIsWeb) {
          try {
            _capturedImage = File(photo.path);
          } catch (_) {}
        }
        _currentPhase = 2;
        if (_maxReachedPhase < 2) _maxReachedPhase = 2;
      });
      _startEnhancement();
    }
  }

  // --- Phase 2 Handlers ---
  void _startEnhancement() async {
    setState(() {
      _isEnhancing = true;
      _enhanceStep = 0;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _enhanceStep = 1);

    try {
      if (_capturedImageBytes != null && _capturedImageBytes!.isNotEmpty) {
        final apiClient = ref.read(apiClientProvider);
        final bytes = await apiClient.enhanceImage(imageBytes: _capturedImageBytes);
        if (mounted) {
          setState(() {
            _enhancedBytes = bytes;
            _enhanceStep = 2;
            _isEnhancing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _enhanceStep = 2;
            _isEnhancing = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Enhancement notice: $e');
      if (mounted) {
        setState(() {
          _enhancedBytes = _capturedImageBytes;
          _enhanceStep = 2;
          _isEnhancing = false;
        });
      }
    }
  }

  // --- Phase 3 Handlers (Voice & STT) ---
  void _toggleRecording() async {
    if (!_isRecording) {
      try {
        final hasPerm = await _audioRecorder.hasPermission();
        if (!hasPerm) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Microphone permission required for voice notes.')),
            );
          }
          return;
        }

        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000, sampleRate: 44100),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordSeconds = 0;
          _recordedAudioPath = path;
        });

        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() => _recordSeconds++);
          if (_recordSeconds >= 60) {
            _toggleRecording();
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not start recording: $e')),
          );
        }
      }
    } else {
      _recordTimer?.cancel();
      try {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
          if (path != null) _recordedAudioPath = path;
        });

        if (_recordedAudioPath != null) {
          _generateCatalogFromAudio(File(_recordedAudioPath!));
        }
      } catch (e) {
        setState(() => _isRecording = false);
      }
    }
  }

  Future<void> _generateCatalogFromAudio(File audioFile) async {
    setState(() => _isCataloging = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final catalog = await apiClient.generateCatalog(audioFile: audioFile);
      _applyCatalogResult(catalog);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Voice processing error: $e. You can also type a description below.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCataloging = false);
    }
  }

  Future<void> _generateCatalogFromText() async {
    final text = _manualPromptController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please speak or type a short description first.')),
      );
      return;
    }

    setState(() => _isCataloging = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final catalog = await apiClient.generateCatalog(textDesc: text);
      _applyCatalogResult(catalog);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Catalog generation error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isCataloging = false);
    }
  }

  void _applyCatalogResult(ProductCatalogGenerated catalog) {
    if (!mounted) return;
    setState(() {
      if (catalog.titleEn.isNotEmpty) _titleEnController.text = catalog.titleEn;
      if (catalog.titleHi.isNotEmpty) _titleHiController.text = catalog.titleHi;
      if (catalog.descriptionEn.isNotEmpty) _descEnController.text = catalog.descriptionEn;
      if (catalog.descriptionHi.isNotEmpty) _descHiController.text = catalog.descriptionHi;
      if (catalog.craftCategory.isNotEmpty) _craftCategory = catalog.craftCategory;
      if (catalog.suggestedTags.isNotEmpty) _tags = catalog.suggestedTags;
      if (catalog.primaryMaterial.isNotEmpty) _materials = [catalog.primaryMaterial];
      
      // Also fill material cost if vision provided an estimate
      if (catalog.estimatedMaterialCostInr > 0) {
        _materialCostController.text = catalog.estimatedMaterialCostInr.toString();
      }

      // Effort Details: Labor Hours
      if (catalog.estimatedLaborHours > 0) {
        _laborHoursController.text = catalog.estimatedLaborHours.toString();
      }

      // Effort Details: Primary Material Dropdown matching
      const validMaterials = [
        'Cotton', 'Clay', 'Bamboo', 'Silk', 'Wood', 'Canvas', 
        'Silver', 'Brass', 'Gold', 'Stone', 'Cane', 'Leather', 
        'Bronze', 'Wool', 'Jute', 'Copper', 'Terracotta'
      ];
      final matchedMat = validMaterials.firstWhere(
        (m) => catalog.primaryMaterial.toLowerCase().contains(m.toLowerCase()),
        orElse: () => '',
      );
      if (matchedMat.isNotEmpty) {
        _materialTypeDropdownValue = matchedMat;
      }

      // Effort Details: Complexity Dropdown matching
      final compLower = catalog.complexity.toLowerCase();
      if (['simple', 'moderate', 'intricate'].contains(compLower)) {
        _complexityDropdownValue = compLower;
      }
    });
  }

  Future<void> _prefillFromVision() async {
    final imagePayload = _enhancedBytes ?? _capturedImageBytes;
    if (imagePayload == null || imagePayload.isEmpty) return;
    setState(() => _isVisionAnalyzing = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final catalog = await apiClient.generateCatalogFromImage(imagePayload);
      _applyCatalogResult(catalog);
    } catch (e) {
      // Silent fail — artisan can still fill manually
      debugPrint('[VisionPrefill] failed: $e');
    } finally {
      if (mounted) setState(() => _isVisionAnalyzing = false);
    }
  }

  // --- Phase 4 Handlers (Pricing Assistant) ---
  Future<void> _fetchDynamicPricing() async {
    setState(() => _isCalculatingPricing = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final imagePayload = _enhancedBytes ?? _capturedImageBytes;

      int mappedComplexity = 3;
      if (_complexityDropdownValue == 'simple') mappedComplexity = 1;
      else if (_complexityDropdownValue == 'intricate') mappedComplexity = 5;

      final pricing = await apiClient.suggestPrice(
        category: _craftCategory,
        materialCost: _materialCost,
        manufacturingHours: _manufacturingHours,
        productDescription: _descEnController.text.isNotEmpty
            ? _descEnController.text
            : _titleEnController.text,
        imageBytes: imagePayload,
        materialType: _materialTypeDropdownValue,
        productComplexity: mappedComplexity,
      );

      if (mounted) {
        setState(() {
          _minPrice = pricing.fairWageFloorInr ?? pricing.minimumBreakevenPrice;
          _suggestedPrice = pricing.suggestedRetailPrice;
          _premiumPrice = (_suggestedPrice * 1.35).roundToDouble();
          _selectedPrice = _suggestedPrice;
          _b2bPrice = pricing.suggestedB2BPrice;
          _pricingNotes = pricing.explanation;
          _competitorRange = pricing.competitorRange;
          _marketAvg = pricing.marketAvg;
          _marketMin = pricing.marketMin;
          _marketMax = pricing.marketMax;
          _complexity = pricing.complexity;
          _fairWageFloor = pricing.fairWageFloorInr;
          _shapTopFeatures = pricing.shapTopFeatures;
          _mlEngineUsed = pricing.mlEngineUsed;
        });
      }
    } catch (e) {
      debugPrint("Dynamic pricing error: $e");
      if (mounted) {
        setState(() {
          final laborBase = _manufacturingHours * 150.0;
          _minPrice = (laborBase * 1.3).roundToDouble();
          _suggestedPrice = (_materialCost * 1.5 + laborBase * 1.3).roundToDouble();
          _premiumPrice = (_suggestedPrice * 1.35).roundToDouble();
          _selectedPrice = _suggestedPrice;
          _b2bPrice = (_selectedPrice * 0.82).roundToDouble();
          _competitorRange = '₹ ${_minPrice.toStringAsFixed(0)} – ₹ ${_premiumPrice.toStringAsFixed(0)}';
          _pricingNotes = 'Calculated based on raw material cost (₹$_materialCost) and ₹150/hr artisan living wage baseline for $_manufacturingHours hours.';
        });
      }
    } finally {
      if (mounted) setState(() => _isCalculatingPricing = false);
    }
  }

  void _onListProduct() async {
    setState(() => _isListing = true);

    try {
      final apiClient = ref.read(apiClientProvider);

      // Encode image bytes as base64 data URI
      String? base64Image;
      final bytesToUpload = _enhancedBytes ?? _capturedImageBytes;
      if (bytesToUpload != null && bytesToUpload.isNotEmpty) {
        base64Image = 'data:image/png;base64,${base64Encode(bytesToUpload)}';
      } else if (!kIsWeb && _capturedImage != null && _capturedImage!.existsSync()) {
        final bytes = await _capturedImage!.readAsBytes();
        base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      await apiClient.createProduct(
        titleEn: _titleEnController.text.trim().isNotEmpty ? _titleEnController.text.trim() : 'Artisan Handcrafted Creation',
        titleHi: _titleHiController.text.trim().isNotEmpty ? _titleHiController.text.trim() : 'हस्तनिर्मित शिल्प उत्पाद',
        descriptionEn: _descEnController.text.trim().isNotEmpty ? _descEnController.text.trim() : null,
        descriptionHi: _descHiController.text.trim().isNotEmpty ? _descHiController.text.trim() : null,
        category: _craftCategory,
        materials: _materials.isNotEmpty ? _materials : ['Natural Materials'],
        tags: _tags,
        retailPrice: _selectedPrice,
        b2bPrice: _b2bPrice > 0 ? _b2bPrice : (_selectedPrice * 0.85),
        stock: 10,
        imageUrl: base64Image,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('🎉 Product successfully published with enhanced photo to Marketplace!'),
          ),
        );
        context.go('/artisan/catalog');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Listing failed: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isListing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text('${l10n.aiCameraStudio} — Phase $_currentPhase/4'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Phase Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: AppColors.surface,
              child: Row(
                children: [
                  _buildPhaseTab(1, 'Capture', Icons.camera_alt),
                  _buildPhaseDivider(1),
                  _buildPhaseTab(2, 'Enhance', Icons.auto_fix_high),
                  _buildPhaseDivider(2),
                  _buildPhaseTab(3, 'Catalog', Icons.mic),
                  _buildPhaseDivider(3),
                  _buildPhaseTab(4, 'Pricing', Icons.currency_rupee),
                ],
              ),
            ),
            Expanded(
              child: _buildCurrentPhaseBody(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseTab(int phase, String label, IconData icon) {
    final isActive = _currentPhase == phase;
    final isDone = _maxReachedPhase > phase || _currentPhase > phase;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (phase <= _maxReachedPhase) {
            setState(() => _currentPhase = phase);
          }
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isDone
                  ? AppColors.success
                  : isActive
                      ? AppColors.primary
                      : AppColors.border,
              child: Icon(
                isDone ? Icons.check : icon,
                size: 14,
                color: isActive || isDone ? Colors.white : AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseDivider(int phase) {
    return Container(
      width: 16,
      height: 2,
      color: _currentPhase > phase ? AppColors.success : AppColors.border,
    );
  }

  Widget _buildCurrentPhaseBody(AppLocalizations l10n) {
    switch (_currentPhase) {
      case 1:
        return _buildPhase1Capture(l10n);
      case 2:
        return _buildPhase2Enhance(l10n);
      case 3:
        return _buildPhase3VoiceCataloger(l10n);
      case 4:
        return _buildPhase4Pricing(l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================
  // PHASE 1: CAPTURE
  // ==========================================
  Widget _buildPhase1Capture(AppLocalizations l10n) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF1A1A24),
          child: Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  l10n.placeProductHere,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
              onPressed: () => setState(() => _isTorchOn = !_isTorchOn),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  onPressed: _pickFromGallery,
                ),
              ),
              GestureDetector(
                onTap: _pickFromCamera,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.black87, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 52),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PHASE 2: AI ENHANCEMENT
  // ==========================================
  Widget _buildPhase2Enhance(AppLocalizations l10n) {
    if (_isEnhancing) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
              const SizedBox(height: 28),
              Text('AI Studio Processing', style: AppTextStyles.heading),
              const SizedBox(height: 16),
              _buildProgressStep('Removing background with u2netp...', _enhanceStep >= 0),
              _buildProgressStep('Balancing edge studio lighting...', _enhanceStep >= 1),
              _buildProgressStep('Formatting 800x800 e-commerce canvas...', _enhanceStep >= 2),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Studio Quality: Enhanced',
                      style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _showAfter = !_showAfter),
                icon: const Icon(Icons.compare, size: 18),
                label: Text(_showAfter ? 'Show Original' : 'Show Enhanced'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.white,
                child: Center(
                  child: (_showAfter && _enhancedBytes != null)
                      ? Image.memory(_enhancedBytes!, fit: BoxFit.contain)
                      : _capturedImageBytes != null
                          ? Image.memory(_capturedImageBytes!, fit: BoxFit.contain)
                          : (!kIsWeb && _capturedImage != null
                              ? Image.file(_capturedImage!, fit: BoxFit.contain)
                              : const Icon(Icons.image, size: 100, color: Colors.grey)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.retake,
                  variant: AppButtonVariant.outlined,
                  onPressed: () => setState(() => _currentPhase = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppButton(
                  label: l10n.useThisPhoto,
                  onPressed: () {
                    setState(() {
                      _currentPhase = 3;
                      if (_maxReachedPhase < 3) _maxReachedPhase = 3;
                    });
                    // Fire Groq vision analysis in background
                    _prefillFromVision();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            color: isDone ? AppColors.success : AppColors.textDisabled,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: isDone ? AppColors.textPrimary : AppColors.textDisabled,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PHASE 3: VOICE & TEXT MULTILINGUAL CATALOGER
  // ==========================================
  Widget _buildPhase3VoiceCataloger(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.voiceCataloger,
            style: AppTextStyles.display.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            'AI scans the image and pre-fills details. Speak or type to refine.',
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Vision AI Analyzing Banner
          if (_isVisionAnalyzing) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.accent.withValues(alpha: 0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🤖 Groq Vision is analyzing your product image...',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Microphone Voice Recording Card
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _isCataloging ? null : _toggleRecording,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: _isRecording ? AppColors.error : AppColors.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (_isRecording)
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      size: 36,
                      color: _isRecording ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isRecording
                      ? 'Recording... 00:${_recordSeconds.toString().padLeft(2, '0')} / 01:00 (Tap to stop)'
                      : 'Tap mic to describe your craft (Hindi, Tamil, Bengali, etc.)',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _isRecording ? AppColors.error : AppColors.textPrimary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Manual text prompt option
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Or type keywords / description:',
                  style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _manualPromptController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Handmade terracotta vase with floral warli painting...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _isCataloging ? null : _generateCatalogFromText,
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('✨ AI Auto-Catalog'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (_isCataloging) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Translating voice & creating bilingual e-commerce catalog...'),
                  ],
                ),
              ),
            ),
          ] else ...[
            // ── Product Title (EN) ──
            AppTextField(
              controller: _titleEnController,
              label: l10n.titleEn,
              hint: 'e.g. Handcrafted Terracotta Floral Vase',
            ),
            const SizedBox(height: 12),

            // ── Product Description (EN) ──
            AppTextField(
              controller: _descEnController,
              label: l10n.descEn,
              hint: 'English description highlighting artisanal heritage...',
              maxLines: 3,
            ),
            const SizedBox(height: 14),

            // ── Raw Material Cost ──
            AppTextField(
              controller: _materialCostController,
              label: 'Raw Material Cost (₹)',
              keyboardType: TextInputType.number,
              hint: 'e.g. 450  (AI pre-filled — edit if needed)',
            ),
            const SizedBox(height: 14),

            // ── Category Dropdown ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: [
                        'Textiles', 'Pottery', 'Jewelry', 'Folk Painting',
                        'Wood Inlay', 'Metalcraft', 'Tribal Craft', 'Handicrafts',
                      ].contains(_craftCategory) ? _craftCategory : 'Handicrafts',
                      isExpanded: true,
                      items: const [
                        'Textiles', 'Pottery', 'Jewelry', 'Folk Painting',
                        'Wood Inlay', 'Metalcraft', 'Tribal Craft', 'Handicrafts',
                      ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _craftCategory = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── SEO Hashtags / Tags ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'SEO Hashtags',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // Add a new empty tag via a quick dialog
                        final ctrl = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Add Hashtag'),
                            content: TextField(
                              controller: ctrl,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'e.g. handmadeIndia',
                                prefixText: '#',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final tag = ctrl.text.trim();
                                  if (tag.isNotEmpty) {
                                    setState(() => _tags = [..._tags, tag]);
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    ..._tags.map((t) => Chip(
                      label: Text('#$t', style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                      deleteIconColor: AppColors.textSecondary,
                      visualDensity: VisualDensity.compact,
                      onDeleted: () => setState(() => _tags = _tags.where((e) => e != t).toList()),
                    )),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Cost & Effort Details (Pricing Engine)
            Text(
              'Effort Details (For Pricing Engine)',
              style: AppTextStyles.heading.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _laborHoursController,
              label: 'Labor (Hours)',
              keyboardType: TextInputType.number,
              hint: 'e.g. 4.5',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Primary Material',
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _materialTypeDropdownValue,
                            isExpanded: true,
                            items: const [
                              'Cotton', 'Clay', 'Bamboo', 'Silk', 'Wood', 'Canvas', 
                              'Silver', 'Brass', 'Gold', 'Stone', 'Cane', 'Leather', 
                              'Bronze', 'Wool', 'Jute', 'Copper', 'Terracotta'
                            ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _materialTypeDropdownValue = val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complexity',
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _complexityDropdownValue,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: 'simple', child: Text('Simple')),
                              DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
                              DropdownMenuItem(value: 'intricate', child: Text('Intricate')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _complexityDropdownValue = val);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            AppButton(
              label: 'Proceed to Pricing Assistant',
              onPressed: () {
                setState(() {
                  _materialCost = double.tryParse(_materialCostController.text.trim()) ?? 0.0;
                  _manufacturingHours = double.tryParse(_laborHoursController.text.trim()) ?? 0.0;
                  _currentPhase = 4;
                  if (_maxReachedPhase < 4) _maxReachedPhase = 4;
                });
                _fetchDynamicPricing();
              },
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // PHASE 4: PRICING ASSISTANT
  // ==========================================
  Widget _buildPhase4Pricing(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.pricingAssistant,
            style: AppTextStyles.display.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            'Dynamic pricing engine benchmarking market trends and living wage multipliers.',
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 20),

          if (_isCalculatingPricing) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Analyzing market trends & calculating fair pricing...'),
                  ],
                ),
              ),
            ),
          ] else ...[
            // 3-Tier Price Cards
            Row(
              children: [
                Expanded(
                  child: _buildPriceCard(
                    title: 'Minimum',
                    price: _minPrice,
                    subtitle: 'Fair Wage Floor',
                    isSelected: _selectedPrice == _minPrice,
                    color: Colors.grey,
                    onTap: () => setState(() {
                      _selectedPrice = _minPrice;
                      _b2bPrice = _minPrice * 0.85;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceCard(
                    title: 'Suggested ★',
                    price: _suggestedPrice,
                    subtitle: 'Market Match',
                    isSelected: _selectedPrice == _suggestedPrice,
                    color: AppColors.accent,
                    onTap: () => setState(() {
                      _selectedPrice = _suggestedPrice;
                      _b2bPrice = _suggestedPrice * 0.85;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceCard(
                    title: 'Premium',
                    price: _premiumPrice,
                    subtitle: 'Heritage Retail',
                    isSelected: _selectedPrice == _premiumPrice,
                    color: const Color(0xFF1ABC9C),
                    onTap: () => setState(() {
                      _selectedPrice = _premiumPrice;
                      _b2bPrice = _premiumPrice * 0.85;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Raw Material Cost Input & Hours
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.materialCost, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.heading.copyWith(fontSize: 16),
                        decoration: InputDecoration(
                          prefixText: '₹ ',
                          hintText: '450',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        controller: TextEditingController(text: _materialCost.toStringAsFixed(0))
                          ..selection = TextSelection.collapsed(offset: _materialCost.toStringAsFixed(0).length),
                        onSubmitted: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null && parsed > 0) {
                            setState(() => _materialCost = parsed);
                            _fetchDynamicPricing();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Labor Hours', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 6),
                      TextField(
                        keyboardType: TextInputType.number,
                        style: AppTextStyles.heading.copyWith(fontSize: 16),
                        decoration: InputDecoration(
                          suffixText: 'hrs',
                          hintText: '4',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        controller: TextEditingController(text: _manufacturingHours.toStringAsFixed(1))
                          ..selection = TextSelection.collapsed(offset: _manufacturingHours.toStringAsFixed(1).length),
                        onSubmitted: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed != null && parsed > 0) {
                            setState(() => _manufacturingHours = parsed);
                            _fetchDynamicPricing();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Wholesale & Competitor Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Complexity badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _complexity == 'intricate'
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : _complexity == 'moderate'
                                  ? AppColors.accent.withValues(alpha: 0.15)
                                  : AppColors.border,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Complexity: ${_complexity[0].toUpperCase()}${_complexity.substring(1)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _complexity == 'intricate'
                                ? AppColors.primary
                                : _complexity == 'moderate'
                                    ? const Color(0xFFD68910)
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text('B2B Wholesale:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(width: 6),
                      Text('\u20b9 ${_b2bPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 15)),
                    ],
                  ),
                  // Market range bar (only shown when platform data exists)
                  if (_marketMin > 0 && _marketMax > 0) ...[
                    const SizedBox(height: 14),
                    Text('Platform Market Range', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final range = _marketMax - _marketMin;
                        final selectedFraction = range > 0
                            ? ((_selectedPrice - _marketMin) / range).clamp(0.0, 1.0)
                            : 0.5;
                        final avgFraction = range > 0
                            ? ((_marketAvg - _marketMin) / range).clamp(0.0, 1.0)
                            : 0.5;
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [AppColors.success.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.5)],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                // Avg marker
                                Positioned(
                                  left: constraints.maxWidth * avgFraction - 1,
                                  child: Container(width: 2, height: 8, color: AppColors.accent),
                                ),
                                // Selected price marker
                                Positioned(
                                  left: (constraints.maxWidth * selectedFraction - 6).clamp(0.0, constraints.maxWidth - 12),
                                  top: -3,
                                  child: Container(
                                    width: 14, height: 14,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('\u20b9 ${_marketMin.toStringAsFixed(0)}', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                                Text('Avg \u20b9 ${_marketAvg.toStringAsFixed(0)}', style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.accent)),
                                Text('\u20b9 ${_marketMax.toStringAsFixed(0)}', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ] else if (_competitorRange != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimated Range:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        Text(_competitorRange!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Strategy notes card
            AppCard(
              child: ExpansionTile(
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Text(l10n.howCalculated, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield_outlined, size: 12, color: AppColors.success),
                          SizedBox(width: 4),
                          Text('MoSJE Living Wage Floor', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Text(
                    _pricingNotes,
                    style: AppTextStyles.caption.copyWith(height: 1.5, fontSize: 13),
                  ),
                  if (_shapTopFeatures != null && _shapTopFeatures!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    const Text('Top Price Drivers (SHAP AI Explainability):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _shapTopFeatures!.map((feat) {
                        final desc = feat['description']?.toString() ?? feat['feature']?.toString() ?? '';
                        final val = (feat['shap_value'] as num?)?.toDouble() ?? 0.0;
                        final isPositive = val >= 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPositive ? AppColors.success.withValues(alpha: 0.08) : AppColors.accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isPositive ? AppColors.success.withValues(alpha: 0.3) : AppColors.accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '$desc (${isPositive ? '+' : ''}₹ ${val.toStringAsFixed(0)})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isPositive ? AppColors.success : const Color(0xFFD68910),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (_mlEngineUsed != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      '⚡ Engine: $_mlEngineUsed',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 28),

            AppButton(
              label: l10n.listProduct,
              isLoading: _isListing,
              onPressed: _onListProduct,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceCard({
    required String title,
    required double price,
    required String subtitle,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '₹ ${price.toStringAsFixed(0)}',
              style: AppTextStyles.heading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
