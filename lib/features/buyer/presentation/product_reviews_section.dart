import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/product_model.dart';

class ProductReviewsSection extends ConsumerStatefulWidget {
  final String productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  ConsumerState<ProductReviewsSection> createState() =>
      _ProductReviewsSectionState();
}

class _ProductReviewsSectionState
    extends ConsumerState<ProductReviewsSection> {
  List<ReviewModel> _reviews = [];
  bool _loading = true;
  bool _showForm = false;
  bool _submitting = false;

  // Form state
  int _rating = 5;
  int _hoverRating = 0;
  bool _isRecommended = true;
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.getProductReviews(widget.productId);
      if (mounted) {
        setState(() {
          _reviews = data;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitReview() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name.')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      final api = ref.read(apiClientProvider);
      final newReview = await api.createProductReview(
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text.trim(),
        reviewerName: _nameController.text.trim(),
        isRecommended: _isRecommended,
      );
      if (mounted) {
        setState(() {
          _reviews.insert(0, newReview);
          _showForm = false;
          _rating = 5;
          _isRecommended = true;
          _nameController.clear();
          _commentController.clear();
          _submitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your review!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    }
  }

  double get _avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.fold(0.0, (sum, r) => sum + r.rating) / _reviews.length;
  }

  int get _recommendPct {
    if (_reviews.isEmpty) return 0;
    final rec = _reviews.where((r) => r.isRecommended).length;
    return ((rec / _reviews.length) * 100).round();
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  (review.reviewerName.isNotEmpty
                          ? review.reviewerName[0]
                          : 'A')
                      .toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 14,
                          color: i < review.rating
                              ? const Color(0xFFF59E0B)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (review.isRecommended)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.thumb_up_alt_rounded,
                          size: 11, color: AppColors.success),
                      SizedBox(width: 3),
                      Text('Recommends',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.comment!,
              style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.45),
            ),
          ],
          if (review.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              '${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}',
              style: AppTextStyles.caption.copyWith(fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer Reviews',
              style: AppTextStyles.heading.copyWith(fontSize: 18),
            ),
            TextButton.icon(
              icon: Icon(
                _showForm ? Icons.close : Icons.rate_review_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              label: Text(
                _showForm ? 'Cancel' : 'Write a Review',
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              onPressed: () => setState(() => _showForm = !_showForm),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Rating Summary Bar
        if (_reviews.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      _avgRating.toStringAsFixed(1),
                      style: AppTextStyles.display.copyWith(
                          fontSize: 36, color: AppColors.primary),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < _avgRating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 16,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                    Text(
                      '${_reviews.length} review${_reviews.length != 1 ? 's' : ''}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const VerticalDivider(width: 1),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$_recommendPct% Recommend',
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success)),
                    const SizedBox(height: 2),
                    Text('this product',
                        style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Write a Review Form
        if (_showForm) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share Your Experience',
                    style: AppTextStyles.heading.copyWith(fontSize: 15)),
                const SizedBox(height: 12),
                // Star Rating
                Text('Your Rating', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = starIndex),
                      onPanUpdate: (details) {
                        // allow sliding
                      },
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => _hoverRating = starIndex),
                        onExit: (_) => setState(() => _hoverRating = 0),
                        child: Icon(
                          starIndex <= (_hoverRating > 0 ? _hoverRating : _rating)
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 34,
                          color: starIndex <=
                                  (_hoverRating > 0 ? _hoverRating : _rating)
                              ? const Color(0xFFF59E0B)
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                // Recommend toggle
                Row(
                  children: [
                    Switch(
                      value: _isRecommended,
                      activeTrackColor: AppColors.success.withValues(alpha: 0.5),
                      activeThumbColor: AppColors.success,
                      onChanged: (v) => setState(() => _isRecommended = v),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isRecommended
                          ? 'I recommend this product'
                          : 'I do not recommend this',
                      style: AppTextStyles.body.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 10),
                // Comment
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Your Review (optional)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitting ? null : _submitReview,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded, size: 16),
                    label: Text(_submitting ? 'Submitting...' : 'Submit Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Reviews List
        if (_loading)
          const Center(
              child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ))
        else if (_reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(Icons.rate_review_outlined,
                    size: 40, color: AppColors.textSecondary),
                const SizedBox(height: 10),
                Text('No reviews yet',
                    style: AppTextStyles.heading.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text('Be the first to recommend this product!',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center),
              ],
            ),
          )
        else
          Column(
            children: _reviews.map(_buildReviewCard).toList(),
          ),

        const SizedBox(height: 32),
      ],
    );
  }
}
