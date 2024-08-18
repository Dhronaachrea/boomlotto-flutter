class EmailOtpVerifiedResponseModel {
  String? errorMessage;
  int? errorCode;
  String? data;

  EmailOtpVerifiedResponseModel({this.errorMessage, this.errorCode, this.data});

  EmailOtpVerifiedResponseModel.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorMessage'] = errorMessage;
    data['errorCode'] = errorCode;
    data['data'] = this.data;
    return data;
  }
}