class LoginModel {
  String? errorMessage;
  int? errorCode;
  Data? data;

  LoginModel(
      {required this.errorMessage,
      required this.errorCode,
      required this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorMessage'] = errorMessage;
    data['errorCode'] = errorCode;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  int? mobVerificationExpiry;
  String? mobVerificationCode;
  dynamic emailId;
  dynamic emailVerificationExpiry;
  int? id;
  String? mobileNo;
  String? otpActionType;
  int? domainId;
  dynamic emailVerificationCode;

  Data(
      {required this.mobVerificationExpiry,
      required this.mobVerificationCode,
      required this.emailId,
      required this.emailVerificationExpiry,
      required this.id,
      required this.mobileNo,
      required this.otpActionType,
      required this.domainId,
      required this.emailVerificationCode});

  Data.fromJson(Map<String, dynamic> json) {
    mobVerificationExpiry = json['mobVerificationExpiry'];
    mobVerificationCode = json['mobVerificationCode'];
    emailId = json['emailId'];
    emailVerificationExpiry = json['emailVerificationExpiry'];
    id = json['id'];
    mobileNo = json['mobileNo'];
    otpActionType = json['otpActionType'];
    domainId = json['domainId'];
    emailVerificationCode = json['emailVerificationCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobVerificationExpiry'] = mobVerificationExpiry;
    data['mobVerificationCode'] = mobVerificationCode;
    data['emailId'] = emailId;
    data['emailVerificationExpiry'] = emailVerificationExpiry;
    data['id'] = id;
    data['mobileNo'] = mobileNo;
    data['otpActionType'] = otpActionType;
    data['domainId'] = domainId;
    data['emailVerificationCode'] = emailVerificationCode;
    return data;
  }
}
