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

  static const updateUserUrl = '/users/update_user';
  //Team member
  static const getSubCaByCaId = '/sub_ca/get_subCA_by_CAId';
  //Customer Url
  static var getCustomerBySubCaId = '/customer/get_customer_by_subCaId';
  static var getCustomerByCaId = '/customer/get_customer_by_caId';
  //Document url
  static var getRecentDocumentUrl =
      '/ca/get_recent_document_uploaded_by_customer';
  static var getViewDocumentUrl = '/document/get_document_by_userId';
  //sate url
  static var stateBaseUrl = 'https://countriesnow.space';
  static var getStateNameUrl = '/api/v0.1/countries/states';
}
