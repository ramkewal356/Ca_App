import 'package:bloc/bloc.dart';
import 'package:ca_app/data/local_storage/shared_prefs_class.dart';
import 'package:ca_app/data/models/add_contact_model.dart';
import 'package:ca_app/data/models/get_contact_by_contactid_model.dart';
import 'package:ca_app/data/models/get_contact_by_userid_model.dart';
import 'package:ca_app/data/repositories/help_and_support_repository.dart';
import 'package:ca_app/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'help_and_support_event.dart';
part 'help_and_support_state.dart';

class HelpAndSupportBloc
    extends Bloc<HelpAndSupportEvent, HelpAndSupportState> {
  final _myRepo = HelpAndSupportRepository();
  int pageNumber = 0;
  int pageSize = 4;
  bool isLastPage = false;
  bool isFetching = false;
  HelpAndSupportBloc() : super(HelpAndSupportInitial()) {
    on<AddContactEvent>(_addContactApi);
    on<GetContactByUserIdEvent>(_getContactByUserIdApi);
    on<GetContactByContactIdEvent>(_getContactByContactIdApi);
  }
  Future<void> _addContactApi(
      AddContactEvent event, Emitter<HelpAndSupportState> emit) async {
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> body = {
      if (event.isAuthorize && userId != null) "userId": userId,
      "email": event.email,
      "subject": event.subject,
      "message": event.message
    };
    try {
      emit(HelpAndSupportLoading());
      var resp = await _myRepo.addContactApi(
          body: body, isAuthorized: event.isAuthorize);
      Utils.toastSuccessMessage('Your Message Sent Successfully');
      emit(AddContactSuccess(addContactModel: resp));
    } catch (e) {
      emit(HelpAndSupportError(error: e.toString()));
    }
  }

  Future<void> _getContactByUserIdApi(
      GetContactByUserIdEvent event, Emitter<HelpAndSupportState> emit) async {
    if (isFetching) return;
    bool isNewSearch = (event.isSearch || event.isFilter);
    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(HelpAndSupportLoading());
    }
    if (isLastPage) return;
    isFetching = true;
    int? userId = await SharedPrefsClass().getUserId();
    debugPrint('userId.,.,.,.,.,.,., $userId');
    Map<String, dynamic> query = {
      "userId": userId,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "search": event.searchText,
      "filter": event.filterText
    };
    try {
      var resp = await _myRepo.getContactByUserId(query: query);
      List<ContactData> newData = resp.data?.content ?? [];
      List<ContactData> allData = (pageNumber == 0)
          ? newData
          : [
              ...(state is GetContactByUserIdSuccess
                  ? (state as GetContactByUserIdSuccess).getContactByUserIdList
                  : []),
              ...newData
            ];
      isLastPage = newData.length < pageSize;
      emit(GetContactByUserIdSuccess(
          getContactByUserIdList: allData, isLastPage: isLastPage));
      pageNumber++;
    } catch (e) {
      emit(HelpAndSupportError(error: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _getContactByContactIdApi(GetContactByContactIdEvent event,
      Emitter<HelpAndSupportState> emit) async {
    Map<String, dynamic> query = {
      "contactId": event.contactId,
    };
    try {
      emit(GetContactByContactIdLoading(contactid: event.contactId));
      var resp = await _myRepo.getContactByContactIdApi(query: query);
      emit(GetContactByContactIdSuccess(
          getContactByContactIdModel: resp, contactId: event.contactId));
    } catch (e) {
      emit(HelpAndSupportError(error: e.toString()));
    }
  }
}
