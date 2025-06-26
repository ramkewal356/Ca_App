import 'package:bloc/bloc.dart';
import 'package:ca_app/data/models/get_all_title_model.dart';
import 'package:ca_app/data/models/get_ca_degree_list.dart';
import 'package:ca_app/data/models/get_occupation_list_model.dart';
import 'package:ca_app/data/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _myRepo = ProfileRepository();
  ProfileBloc() : super(ProfileInitial()) {
    on<GetAllTitleEvent>(_getAllTitleApi);
    on<GetOccupationEvent>(_getOccupationApi);
  }
  Future<void> _getAllTitleApi(
      GetAllTitleEvent event, Emitter<ProfileState> emit) async {
    try {
      // emit(ProfileLoading());
      var resp = await _myRepo.getAllTitleApi();
      emit(GetTitleSuccess(getAllTitleModel: resp));
    } catch (e) {
      emit(ProfileError());
    }
  }

  Future<void> _getOccupationApi(
      GetOccupationEvent event, Emitter<ProfileState> emit) async {
    try {
      // emit(ProfileLoading());
      var resp = await _myRepo.getOccupationListpi();
      emit(GetOccupationSuccess(getOccupationLIstModel: resp));
    } catch (e) {
      emit(ProfileError());
    }
  }
}

class GetDegreeBloc extends Bloc<ProfileEvent, ProfileState> {
  final _myRepo = ProfileRepository();
  GetDegreeBloc() : super(ProfileInitial()) {
    on<GetCaDegreeEvent>(_getCaDegreeListApi);
  }
  Future<void> _getCaDegreeListApi(
      GetCaDegreeEvent event, Emitter<ProfileState> emit) async {
    try {
      // emit(ProfileLoading());
      var resp = await _myRepo.getCADegreeListpi();
      emit(GetCaDegreeSuccess(getCaDegreeListModel: resp));
    } catch (e) {
      emit(ProfileError());
    }
  }
}
