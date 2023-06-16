abstract class MainStates {}

class InitialState extends MainStates {}

class ChangeBottomNavBarState extends MainStates {}

class ChangeDrawerState extends MainStates {}

class ChangeBottomSheetState extends MainStates {}

class ChangeCalenderState extends MainStates {}

class ChangeLocationState extends MainStates {}

class ChangeStartTimeState extends MainStates {}

class ChangeCarouselOptionState extends MainStates {}

class ChangeIsCommetingState extends MainStates {}

class ProfileImagePickedSuccessState extends MainStates {}

class ProfileImagePickedErrorState extends MainStates {}

class ChangeContainerState extends MainStates {}

class ChangeContainerFState extends MainStates {}

class MultiImagePickedSuccessState extends MainStates {}

class MultiImagePickedDeletedState extends MainStates {}

class FilePickerSuccess extends MainStates {}

class FilePickerError extends MainStates {
  final String message;

  FilePickerError(this.message);
}

class CarCreatePostLoadingState extends MainStates {}

class CarCreatePostSuccessState extends MainStates {}

class CarCreatePostErrorState extends MainStates {}

class ChangeRangeSliderState extends MainStates {}

class userGottenSuccessfully extends MainStates {}

class userGottenUnSuccessfully extends MainStates {}

class ImageLoadingState extends MainStates {}

class ImageLoadingStateError extends MainStates {}

class ProductUploadedSuccessfully extends MainStates {}
