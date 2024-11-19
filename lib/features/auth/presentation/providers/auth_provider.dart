

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(
    authRepository: authRepository,
  );
});



class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}): super( AuthState() );


  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(microseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
      
    } on WrongCredentials {
      logoutUser('Credentials are wrong');
    } catch (e) {
      logoutUser('Error not expected');
    }
  }

  Future<void> registerUser(String email, String password) async {

  }

  Future<void> logoutUser([String? errorMessage]) async {
    // TODO: Limpiar token

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void checkStatus() async {

  }


  void _setLoggedUser(User user) {
    // TODO: Necesito guardar el token en el dispositivo
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }
  
}


enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {


  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = '',
  });


  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
}