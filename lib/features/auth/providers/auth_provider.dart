import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/storage_providers.dart';
import '../../../shared/models/user_model.dart';

enum AuthState {
  initial,
  unauthenticated,
  authenticatedArtisan,
  authenticatedAggregator,
  authenticatedBuyer,
}

class AuthNotifier extends Notifier<AuthState> {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  @override
  AuthState build() {
    _checkAuthStatus();
    return AuthState.initial;
  }

  Future<void> _checkAuthStatus() async {
    final storage = ref.read(localStorageProvider);
    final token = await storage.getToken();
    final role = storage.getUserRole();
    
    if (token != null && token.isNotEmpty) {
      _setCurrentUserFromStorage(storage);
      if (role == 'Aggregator') {
        state = AuthState.authenticatedAggregator;
      } else if (role == 'Buyer') {
        state = AuthState.authenticatedBuyer;
      } else {
        state = AuthState.authenticatedArtisan;
      }
    } else {
      state = AuthState.unauthenticated;
    }
  }

  void _setCurrentUserFromStorage(dynamic storage) {
    final name = storage.getUserName() ?? 'Artisan';
    final phone = storage.getUserPhone();
    final role = storage.getUserRole() ?? 'Artisan';
    final isVerified = storage.isUserVerified();

    _currentUser = UserModel(
      id: 'cached_id',
      username: phone ?? name,
      fullName: name,
      phoneNumber: phone,
      role: role,
      isVerified: isVerified,
    );
  }

  Future<void> loginWithSession({
    required String token,
    required String role,
    String? fullName,
    String? phone,
    bool isVerified = false,
  }) async {
    final storage = ref.read(localStorageProvider);
    await storage.saveUserSession(
      token: token,
      role: role,
      fullName: fullName,
      phone: phone,
      isVerified: isVerified,
    );

    _currentUser = UserModel(
      id: 'active_id',
      username: phone ?? fullName ?? 'User',
      fullName: fullName ?? 'Artisan',
      phoneNumber: phone,
      role: role,
      isVerified: isVerified,
    );

    if (role == 'Aggregator') {
      state = AuthState.authenticatedAggregator;
    } else if (role == 'Buyer') {
      state = AuthState.authenticatedBuyer;
    } else {
      state = AuthState.authenticatedArtisan;
    }
  }

  /// Called after fetching fresh data from the backend (e.g. dashboard/profile)
  /// to sync the locally cached verification status with the server's truth.
  Future<void> refreshUserVerification(bool isVerified) async {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      id: _currentUser!.id,
      username: _currentUser!.username,
      fullName: _currentUser!.fullName,
      phoneNumber: _currentUser!.phoneNumber,
      role: _currentUser!.role,
      isVerified: isVerified,
    );
    // Persist updated status
    final storage = ref.read(localStorageProvider);
    await storage.saveUserSession(
      token: (await storage.getToken()) ?? '',
      role: _currentUser!.role,
      fullName: _currentUser!.fullName,
      phone: _currentUser!.phoneNumber,
      isVerified: isVerified,
    );
    // Notify listeners so banners/badges rebuild
    // We don't change AuthState enum, just touch the notifier so watchers rebuild.
    state = state;
  }

  Future<void> logout() async {
    final storage = ref.read(localStorageProvider);
    await storage.clearAuthSession();
    _currentUser = null;
    state = AuthState.unauthenticated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
