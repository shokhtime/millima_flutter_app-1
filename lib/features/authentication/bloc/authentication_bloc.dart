import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:millima/data/models/models.dart';
import 'package:millima/domain/authentication_repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

enum SocialLoginTypes { google, facebook, github }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState()) {
    on<LoginEvent>(_onLogin);
    on<SocialLoginEvent>(_onSocialLogin);
    on<RegisterEvent>(_onRegister);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
  }

  void _onLogin(
    LoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authenticationRepository.login(event.request);
      emit(state.copyWith(
        status: AuthenticationStatus.authenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSocialLogin(
    SocialLoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      dynamic user;
      switch (event.type) {
        case SocialLoginTypes.google:
          const List<String> scopes = <String>['email'];
          final googleSignIn = GoogleSignIn(scopes: scopes);
          user = await googleSignIn.signIn();
          break;
        case SocialLoginTypes.facebook:
          user = (await FacebookAuth.instance.login());
          break;
        default:
          return;
      }

      print(user);

      // if (user != null) {
      //   await _authenticationRepository.socialLogin(SocialLoginRequest(
      //     name: user.displayName ?? '',
      //     email: user.email,
      //   ));
      //   emit(state.copyWith(
      //     status: AuthenticationStatus.authenticated,
      //     isLoading: false,
      //   ));
      // } else {
      //   throw ('User not found');
      // }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onRegister(
    RegisterEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authenticationRepository.register(event.request);
      emit(state.copyWith(
        status: AuthenticationStatus.authenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onLogout(
    LogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authenticationRepository.logout();
      emit(state.copyWith(
        status: AuthenticationStatus.unauthenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final isLoggedIn = await _authenticationRepository.checkAuthStatus();
      emit(state.copyWith(
        status: isLoggedIn
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
