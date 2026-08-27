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
