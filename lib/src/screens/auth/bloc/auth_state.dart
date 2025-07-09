import "package:dio/dio.dart" as dio;
import "package:equatable/equatable.dart";
import "package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart";

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSentSuccess extends AuthState {
  final dio.Response response;

  const AuthCodeSentSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class AuthVerificationSuccess extends AuthState {
  final AllInfoModel userData;

  const AuthVerificationSuccess(this.userData);

  @override
  List<Object> get props => [userData];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}

class AuthNavigateToHome extends AuthState {}

class AuthNavigateToInfoCollector extends AuthState {
  final AllInfoModel userData;

  const AuthNavigateToInfoCollector(this.userData);

  @override
  List<Object> get props => [userData];
}
