class EndPoints {
  static const baseUrl = 'https://dev-api.cabaonline.in';
  static const loginUrl = '/login';
  static const addNewUserUrl = '/users/add_user';
  static const updateProfileImageUrl = '/users/upload_profile_by_userId';
  static const getUserByIdUrl = '/users/get_user_by_userId';
  static const sendOtpForResetUrl = '/users/send_reset_password_otp';
  static const verifyOtpUrl = '/verify_reset_password_otp';
  static const updateUserUrl = '/users/update_user';
  //Team member
  static const getSubCaByCaId = '/sub_ca/get_subCA_by_CAId';
  //Customer Url
  static var getCustomerBySubCaId = '/customer/get_customer_by_subCaId';
  static var stateBaseUrl = 'https://countriesnow.space';
  static var getStateNameUrl = '/api/v0.1/countries/states';
}
