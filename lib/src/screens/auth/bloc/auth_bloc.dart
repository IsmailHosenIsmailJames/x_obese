import "dart:developer";

import "package:bloc/bloc.dart";
import "package:dio/dio.dart" as dio;
import "package:hive/hive.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/core/common/functions/is_information_fulfilled.dart";
import "package:x_obese/src/screens/auth/bloc/auth_event.dart";
import "package:x_obese/src/screens/auth/bloc/auth_state.dart";
import "package:x_obese/src/screens/auth/repository/auth_repository.dart";
import "package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart";

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<VerifyOTP>(_onVerifyOTP);
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
        await _handleSuccessfulVerification(response);

        final userDataResponse = await authRepository.getUserData();
        if (userDataResponse != null &&
            (userDataResponse.statusCode == 200 ||
                userDataResponse.statusCode == 201)) {
          final userData = AllInfoModel.fromMap(
            Map<String, dynamic>.from(userDataResponse.data["data"]),
          );
          await Hive.box("user").put("info", userData.toJson());

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

  Future<void> _handleSuccessfulVerification(dio.Response response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "access_token",
      response.data["data"]["accessToken"].toString(),
    );

    String? refreshToken = refreshTokenExtractor(response);
    if (refreshToken != null) {
      await prefs.setString("refresh_token", refreshToken);
      log("Saved refresh token", name: "success");
    }
  }
}
