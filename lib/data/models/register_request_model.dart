class RegisterRequestModel {
  int? userId;
  String? password;
  String? gender;
  String? firstName;
  String? address;

  RegisterRequestModel(
      {this.userId, this.password, this.gender, this.firstName, this.address});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    gender = json['gender'];
    firstName = json['firstName'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['password'] = password;
    data['gender'] = gender;
    data['firstName'] = firstName;
    data['address'] = address;
    return data;
  }
}
