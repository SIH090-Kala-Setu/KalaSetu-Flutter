import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Who are you?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Select your role to continue.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),
              _RoleButton(
                title: 'Artisan',
                icon: Icons.brush,
                description: 'I make and sell crafts',
                onTap: () {
                  context.push('/login?role=Artisan');
                },
              ),
              const SizedBox(height: 16),
              _RoleButton(
                title: 'Cluster Aggregator',
                icon: Icons.group,
                description: 'I manage a group of artisans',
                onTap: () {
                  context.push('/login?role=Aggregator');
                },
              ),
              const SizedBox(height: 16),
              _RoleButton(
                title: 'Buyer',
                icon: Icons.shopping_bag,
                description: 'I want to buy crafts in bulk',
                onTap: () {
                  context.push('/login?role=Buyer');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.background,
              radius: 28,
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
