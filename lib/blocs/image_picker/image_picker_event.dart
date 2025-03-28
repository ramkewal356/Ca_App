part of 'image_picker_bloc.dart';

sealed class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends ImagePickerEvent {
  final ImageSource source;
  final bool isProfileImgChange;
  const PickImageEvent({required this.source, this.isProfileImgChange = false});
  @override
  List<Object> get props => [source, isProfileImgChange];
}

// class UpdateProfileImageEvent extends ImagePickerEvent {
//   final File imageFile;
//   const UpdateProfileImageEvent({required this.imageFile});
//   @override
//   List<Object> get props => [imageFile];
// }
