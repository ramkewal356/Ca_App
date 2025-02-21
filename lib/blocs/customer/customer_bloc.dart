import 'package:bloc/bloc.dart';
import 'package:ca_app/data/models/get_customer_by_subca_id_model.dart';
import 'package:ca_app/data/repositories/customer_repository.dart';
import 'package:equatable/equatable.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  int pageNumber = 0;
  final int pageSize = 4;
  bool isFetching = false;
  bool isLastPage = false;
  final _myRepo = CustomerRepository();
  CustomerBloc() : super(CustomerInitial()) {
    on<GetCustomerBySubCaIdEvent>(_getCustomerBySubCaId);
  }
  Future<void> _getCustomerBySubCaId(
      GetCustomerBySubCaIdEvent event, Emitter<CustomerState> emit) async {
    if (isFetching) return;

    bool isNewSearch = (event.isSearch);

    if (isNewSearch && !event.isPagination) {
      pageNumber = 0;
      isLastPage = false;
      emit(CustomerLoading()); // Show loading only for the first page
    }

    // if (isLastPage) return;
    isFetching = true;

    Map<String, dynamic> query = {
      "subCaId": event.subCaId,
      "search": event.searchText,
      "pageNumber": pageNumber,
      "pageSize": pageSize,
    };
    try {
      var resp = await _myRepo.getCustomerBySubCaId(query: query);

      List<Datum> newData = resp.data ?? [];

      // 🔹 If search/filter changed, replace old data. Otherwise, append for pagination.
      List<Datum> allItems = (pageNumber == 0)
          ? newData
          : [
              ...?(state is GetCustomerBySubCaIdSuccess
                  ? (state as GetCustomerBySubCaIdSuccess)
                      .getCustomerBySubCaIdModel
                  : []),
              ...newData
            ];

      isLastPage = newData.length < pageSize;

      emit(GetCustomerBySubCaIdSuccess(getCustomerBySubCaIdModel: allItems));

      // pageNumber++;
    } catch (e) {
      emit(CustomerError(errorMessage: e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
