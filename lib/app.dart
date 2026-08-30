import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/widgets/restart_widget.dart';

class KalaSetuApp extends ConsumerWidget {
  const KalaSetuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider);

    return RestartWidget(
      child: MaterialApp.router(
        title: 'कलाSetu',
        theme: AppTheme.lightTheme,
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => _FcmListener(ref: ref, child: child!),
      ),
    );
  }
}

/// Listens to foreground FCM messages and shows a Material banner.
class _FcmListener extends StatefulWidget {
  final WidgetRef ref;
  final Widget child;
  const _FcmListener({required this.ref, required this.child});

  @override
  State<_FcmListener> createState() => _FcmListenerState();
}

class _FcmListenerState extends State<_FcmListener> {
  @override
  void initState() {
    super.initState();
    FcmService.onForegroundMessage.listen(_showBanner);
  }

  void _showBanner(RemoteMessage message) {
    final notif = message.notification;
    if (notif == null || !mounted) return;
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(notif.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            if (notif.body != null) Text(notif.body!),
          ],
        ),
        leading: const Icon(Icons.notifications_active),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('DISMISS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
