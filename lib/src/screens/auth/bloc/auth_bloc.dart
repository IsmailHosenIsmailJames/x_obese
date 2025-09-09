import "dart:developer";

import "package:bloc/bloc.dart";
import "package:dio/dio.dart" as dio;
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/core/common/functions/is_information_fulfilled.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/auth/bloc/auth_event.dart";
import "package:x_obese/src/screens/auth/bloc/auth_state.dart";
import "package:x_obese/src/screens/auth/repository/auth_repository.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<VerifyOTP>(_onVerifyOTP);
    on<ContinueAsGuest>(_continueAsGuest);
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.signup(event.phone);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        emit(AuthCodeSentSuccess(response));
      } else {
        emit(AuthFailure(response?.data["message"] ?? "Signup Failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(event.phone);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        emit(AuthCodeSentSuccess(response));
      } else {
        emit(AuthFailure(response?.data["message"] ?? "Login Failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOTP(VerifyOTP event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.verifyOTP(
        event.otp,
        event.type,
        event.id,
      );
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        AuthFailure? isFailed = await _handleSuccessfulVerification(response);
        if (isFailed != null) {
          emit(isFailed);
        }

        final userDataResponse = await authRepository.getUserData();
        if (userDataResponse != null &&
            (userDataResponse.statusCode == 200 ||
                userDataResponse.statusCode == 201)) {
          final userData = UserInfoModel.fromMap(
            Map<String, dynamic>.from(userDataResponse.data["data"]),
          );
          await UserDB.saveUserAllInfo(userData);

          await AllInfoController().dataAsync();

          if (isInformationNotFullFilled(userData)) {
            emit(AuthNavigateToInfoCollector(userData));
          } else {
            emit(AuthNavigateToHome());
          }
        } else {
          emit(
            AuthFailure(
              userDataResponse?.data["message"] ?? "Failed to get user data",
            ),
          );
        }
      } else {
        emit(
          AuthFailure(response?.data["message"] ?? "OTP Verification Failed"),
        );
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<AuthFailure?> _handleSuccessfulVerification(
    dio.Response response,
  ) async {
    await UserDB.saveAccessToken(
      response.data["data"]["accessToken"].toString(),
    );
    String? refreshToken = refreshTokenExtractor(response);
    if (refreshToken != null) {
      await UserDB.saveRefreshToken(refreshToken);
      log("Saved refresh token", name: "success");
    } else {
      log("Unable to extract refresh token");
      return const AuthFailure("Unable to extract refresh token");
    }
    return null;
  }

  UserInfoModel? userInfoModel() {
    return UserDB.userAllInfo();
  }

  Future<void> _continueAsGuest(
    ContinueAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    await UserDB.saveUserAllInfo(event.userInfoModel);
    emit(AuthNavigateToHome());
  }
}
