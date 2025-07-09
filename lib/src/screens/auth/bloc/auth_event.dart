import "package:equatable/equatable.dart";

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignupRequested extends AuthEvent {
  final String phone;

  const SignupRequested(this.phone);

  @override
  List<Object> get props => [phone];
}

class LoginRequested extends AuthEvent {
  final String phone;

  const LoginRequested(this.phone);

  @override
  List<Object> get props => [phone];
}

class VerifyOTP extends AuthEvent {
  final String otp;
  final String type;
  final String id;

  const VerifyOTP({required this.otp, required this.type, required this.id});

  @override
  List<Object> get props => [otp, type, id];
}

class GetUserData extends AuthEvent {
  const GetUserData();
}
