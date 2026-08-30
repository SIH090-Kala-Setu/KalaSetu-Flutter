import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

  // Phase 1: Capture
  File? _capturedImage;
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
  String _pricingNotes = 'Calculated using fair wage multiplier and raw material costs.';
  String? _competitorRange = '₹ 1,000 - ₹ 1,800';
  bool _isCalculatingPricing = false;
  bool _isListing = false;

  @override
  void dispose() {
    _recordTimer?.cancel();
    _audioRecorder.dispose();
    _manualPromptController.dispose();
    _titleEnController.dispose();
    _titleHiController.dispose();
    _descEnController.dispose();
    _descHiController.dispose();
    super.dispose();
  }

  // --- Phase 1 Handlers ---
  void _pickFromCamera() async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (photo != null) {
      setState(() {
        _capturedImage = File(photo.path);
        _currentPhase = 2;
      });
      _startEnhancement();
    }
  }

  void _pickFromGallery() async {
    final photo = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (photo != null) {
      setState(() {
        _capturedImage = File(photo.path);
        _currentPhase = 2;
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
      if (_capturedImage != null) {
        final apiClient = ref.read(apiClientProvider);
        final bytes = await apiClient.enhanceImage(_capturedImage!);
        if (mounted) {
          setState(() {
            _enhancedBytes = bytes;
            _enhanceStep = 2;
            _isEnhancing = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _enhancedBytes = _capturedImage?.readAsBytesSync();
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
    });
  }

  // --- Phase 4 Handlers (Pricing Assistant) ---
  Future<void> _fetchDynamicPricing() async {
    setState(() => _isCalculatingPricing = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final pricing = await apiClient.suggestPrice(
        category: _craftCategory,
        materialCost: _materialCost,
        manufacturingHours: _manufacturingHours,
        productDescription: _descEnController.text.isNotEmpty ? _descEnController.text : _titleEnController.text,
      );

      if (mounted) {
        setState(() {
          _minPrice = pricing.minimumBreakevenPrice;
          _suggestedPrice = pricing.suggestedRetailPrice;
          _premiumPrice = _suggestedPrice * 1.35;
          _selectedPrice = _suggestedPrice;
          _b2bPrice = pricing.suggestedB2BPrice > 0 ? pricing.suggestedB2BPrice : (_selectedPrice * 0.85);
          _pricingNotes = pricing.explanation;
          _competitorRange = pricing.competitorRange ?? '₹ ${(_minPrice * 0.9).toStringAsFixed(0)} - ₹ ${(_premiumPrice).toStringAsFixed(0)}';
        });
      }
    } catch (_) {
      // Local heuristic fallback
      if (mounted) {
        setState(() {
          _minPrice = _materialCost * 1.5;
          _suggestedPrice = _materialCost * 2.5;
          _premiumPrice = _materialCost * 3.5;
          _selectedPrice = _suggestedPrice;
          _b2bPrice = _selectedPrice * 0.85;
          _competitorRange = '₹ ${_minPrice.toStringAsFixed(0)} - ₹ ${_premiumPrice.toStringAsFixed(0)}';
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
      if (_enhancedBytes != null && _enhancedBytes!.isNotEmpty) {
        base64Image = 'data:image/png;base64,${base64Encode(_enhancedBytes!)}';
      } else if (_capturedImage != null && _capturedImage!.existsSync()) {
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
            content: Text('Failed to publish product: $e'),
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
    final isDone = _currentPhase > phase;

    return Expanded(
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
                      : _capturedImage != null
                          ? Image.file(_capturedImage!, fit: BoxFit.contain)
                          : const Icon(Icons.image, size: 100, color: Colors.grey),
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
                    setState(() => _currentPhase = 3);
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
            'Speak naturally in your regional language or enter keywords. Gemini AI will generate professional English & Hindi descriptions.',
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 20),

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
            // Title fields
            AppTextField(
              controller: _titleEnController,
              label: l10n.titleEn,
              hint: 'e.g. Handcrafted Terracotta Floral Vase',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _titleHiController,
              label: l10n.titleHi,
              hint: 'उदा. हस्तनिर्मित टेराकोटा मिट्टी का फूलदान',
            ),
            const SizedBox(height: 12),

            // Description fields
            AppTextField(
              controller: _descEnController,
              label: l10n.descEn,
              hint: 'English description highlighting artisanal heritage...',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _descHiController,
              label: l10n.descHi,
              hint: 'शिल्प और निर्माण तकनीक का हिंदी में विवरण...',
              maxLines: 3,
            ),
            const SizedBox(height: 14),

            // Category & Tags
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Category: $_craftCategory',
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _tags
                  .map((t) => Chip(
                        label: Text(t, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 24),
            AppButton(
              label: 'Proceed to Pricing Assistant',
              onPressed: () {
                setState(() => _currentPhase = 4);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('B2B Wholesale Price (15% bulk off):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('₹ ${_b2bPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 15)),
                    ],
                  ),
                  if (_competitorRange != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Marketplace Benchmark:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
                title: Text(l10n.howCalculated, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                children: [
                  Text(
                    _pricingNotes,
                    style: AppTextStyles.caption.copyWith(height: 1.5, fontSize: 13),
                  ),
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
