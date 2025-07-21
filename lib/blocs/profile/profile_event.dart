part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetAllTitleEvent extends ProfileEvent {}

class GetOccupationEvent extends ProfileEvent {}

class GetCaDegreeEvent extends ProfileEvent {}
