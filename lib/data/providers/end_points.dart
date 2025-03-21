class EndPoints {
  static const baseUrl = 'https://dev-api.cabaonline.in';
  static const loginUrl = '/login';
  static const addNewUserUrl = '/users/add_user';
  static const updateProfileImageUrl = '/users/upload_profile_by_userId';
  static const getUserByIdUrl = '/users/get_user_by_userId';
  static const sendOtpForResetUrl = '/users/send_reset_password_otp';
  static const resendOtpForUsersUrl = '/users/send_reset_otp';
  static const verifyOtpUrl = '/verify_reset_password_otp';
  static const verifyOtpForUserUrl = '/verify_otp';
  static const deactiveUserUrl = '/users/activate_deactivate_user';
  static const updateUserUrl = '/users/update_user';
  //Team member
  static const getSubCaByCaId = '/sub_ca/get_subCA_by_CAId';
  static const getVerifiedSubCaByCaId = '/sub_ca/get_verified_subCA_by_caId';
  //Customer Url
  static var getCustomerBySubCaId = '/customer/get_customer_by_subCaId';
  static var getCustomerByCaId = '/customer/get_customer_by_caId';
  static var assignCustomerUrl = '/ca/assign_customer';
  static var getLoginCustomerUrl = '/customer/get_login_customers_by_caId';
  //Document url
  static var getRecentDocumentUrl =
      '/ca/get_recent_document_uploaded_by_customer';
  static var getViewDocumentUrl = '/document/get_document_by_userId';
  //Logs Url
  static var getActiveDeactiveLogByCaIdUrl =
      '/active_deactive_logs/get_all_active_deActive_logs';
  static var getActiveDeactiveLogByUponIdUrl =
      '/active_deactive_logs/get_active_deActive_logs_by_actionUponId';
  // Services url
  static var getServicesListUrl = '/caServices/get_ca_service_list';
  static var getServiceDropdownListUrl = '/service/get_distinct_service';
  static var getSubServiceByServiceNameListUrl =
      '/service/get_subService_by_serviceName';
  static var addServiceUrl = '/caServices/select_service';
  static var createNewServiceUrl = '/caServices/request_service';
  static var deleteServiceUrl = '/caServices/remove_service';
  static var getViewServiceUrl = '/caServices/get_request_service_by_caId';
  //task Url
  static var getSelfTaskUrl = '/task/get_self_assigned_task';
  static var getAssignTaskUrl = '/task/get_assigned_task_by_createdById';
  static var createNewTaskUrl = '/task/add_task';
  static var getViewTaskUrl = '/task/get_task_document';
  static var actionOnTaskUrl = '/task/accept_reject_task';
  static var taskDocumentUploadUrl = '/task/upload_document';
//Raise Request
  static var sendRaiseRequest = '/request/send_request';
  static var getRequestBySenderId = '/request/get_request_by_senderId';
  static var getRequestByRequestId =
      '/request/get_request_document_by_requestId';
  static var getRequestOfClientUrl = '/request/get_request_of_clients_by_caId';
  static var getRequestOfTeamUrl = '/request/get_requests_of_subCa_by_caId';

// Contact Url
  static var addContactUrl = '/contact/add_contact';
  static var getContactByUserIdUrl = '/contact/get_contact_by_userId';
  static var getContactByContactIdUrl = '/contact/get_contact_by_contactId';

  //sate url
  static var stateBaseUrl = 'https://countriesnow.space';
  static var getStateNameUrl = '/api/v0.1/countries/states';
}
