import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventRegister>(
      (event, emit) async {
        await provider.initialize();
        final email = event.email;
        final password = event.password;
        try {
          await provider.createUser(
            email: email,
            password: password,
          );
          await provider.sendEmailVerification();
          final user = provider.currentUser;
          emit(AuthStateLoggedIn(user!));
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );

    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isloading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );

    on<AuthEventLogIn>(
      (event, emit) async {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isloading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isloading: false,
            ),
          );
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isloading: false,
            ),
          );
        }
      },
    );
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isloading: false,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isloading: false,
            ),
          );
        }
      },
    );
  }
}
