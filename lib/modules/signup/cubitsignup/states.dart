abstract class SiginUpState {}

class SiginUpInetialState extends SiginUpState {}

class SiginUpLodingState extends SiginUpState {}

class SiginUpSacsessState extends SiginUpState {}

class FilePickerSuccess extends SiginUpState {}

class FilePickerError extends SiginUpState {
  final String message;

  FilePickerError(this.message);
}

class ImagePickerSuccess extends SiginUpState {}

class ImagePickerError extends SiginUpState {
  final String message;

  ImagePickerError(this.message);
}

class SiginUpErorrState extends SiginUpState {
  late final String error;

  SiginUpErorrState({required this.error});
}

class SiginUpCreetSacsessState extends SiginUpState {
  late final String uId;
  late final String userJobType;
  SiginUpCreetSacsessState({
    required this.uId,
    required this.userJobType,
  });
}

class SiginUpCreetErorrState extends SiginUpState {}

class SiginUpIconState extends SiginUpState {}
