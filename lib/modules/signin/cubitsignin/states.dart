abstract class SignInState {}

class SignInInetialState extends SignInState {}

class SignInLodingState extends SignInState {}

class SignInSacsessState extends SignInState {
  late final String uId;
  late final String jobType;
  SignInSacsessState({required this.uId, required this.jobType});
}

class SignInErorrState extends SignInState {
  final String error;

  SignInErorrState({required this.error});
}

class SignInIconState extends SignInState {}
