part of 'image_picker_bloc.dart';

sealed class ImagePickerState extends Equatable {
  const ImagePickerState();

  @override
  List<Object> get props => [];
}

final class ImagePickerInitial extends ImagePickerState {}

class ProfileImageLoading extends ImagePickerState {}

class ImagePickedSuccess extends ImagePickerState {
  final File? imageFile;
  final File? companyImage;
  const ImagePickedSuccess({this.imageFile, this.companyImage});
  @override
  List<Object> get props => [imageFile!, companyImage!];
}

class ProfileImageUpdated extends ImagePickerState {
  final String imageUrl;
  const ProfileImageUpdated({required this.imageUrl});
  @override
  List<Object> get props => [imageUrl];
}

class ProfileImageError extends ImagePickerState {
  final String message;
  const ProfileImageError({required this.message});
  @override
  List<Object> get props => [message];
}
