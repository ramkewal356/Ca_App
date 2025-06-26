part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class GetTitleSuccess extends ProfileState {
  final GetAllTitleModel getAllTitleModel;

  const GetTitleSuccess({required this.getAllTitleModel});
  @override
  List<Object> get props => [getAllTitleModel];
}

class GetCaDegreeSuccess extends ProfileState {
  final GetCaDegreeListModel getCaDegreeListModel;

  const GetCaDegreeSuccess({required this.getCaDegreeListModel});
  @override
  List<Object> get props => [getCaDegreeListModel];
}

class GetOccupationSuccess extends ProfileState {
  final GetOccupationLIstModel getOccupationLIstModel;

  const GetOccupationSuccess({required this.getOccupationLIstModel});
  @override
  List<Object> get props => [getOccupationLIstModel];
}

class ProfileError extends ProfileState {}
