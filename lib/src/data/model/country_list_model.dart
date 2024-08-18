class CountryListModel {
  String? errorMessage;
  int? errorCode;
  List<Data>? data;

  CountryListModel(
      {required this.errorMessage,
      required this.errorCode,
      required this.data});

  CountryListModel.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    errorCode = json['errorCode'];
    if (json['data'] != null) {
      data = List.filled(0, Data.fromJson(json), growable: true);
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorMessage'] = errorMessage;
    data['errorCode'] = errorCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  bool? isDefault;
  String? flag;
  String? countryCode;
  String? countryName;
  String? isdCode;

  Data(
      {required this.isDefault,
      required this.flag,
      required this.countryCode,
      required this.countryName,
      required this.isdCode});

  Data.fromJson(Map<String, dynamic> json) {
    isDefault = json['isDefault'];
    flag = json['flag'];
    countryCode = json['countryCode'];
    countryName = json['countryName'];
    isdCode = json['isdCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDefault'] = isDefault;
    data['flag'] = flag;
    data['countryCode'] = countryCode;
    data['countryName'] = countryName;
    data['isdCode'] = isdCode;
    return data;
  }
}
