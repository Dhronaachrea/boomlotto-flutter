class PaymentOptionModel {
  int? errorCode;
  PayTypeMap? payTypeMap;

  PaymentOptionModel({this.errorCode, this.payTypeMap});

  PaymentOptionModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    payTypeMap = json['payTypeMap'] != null ? PayTypeMap?.fromJson(json['payTypeMap']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.payTypeMap != null) {
      data['payTypeMap'] = this.payTypeMap?.toJson();
    }
    return data;
  }
}

class PayTypeMap {
  Two? TwoTwo;

  PayTypeMap({required this.TwoTwo});

  PayTypeMap.fromJson(Map<String, dynamic> json) {
  TwoTwo = json['2'] != null ?  Two.fromJson(json['2']) : null;
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  Map<String, dynamic>();
  if (this.TwoTwo != null) {
  data['2'] = this.TwoTwo?.toJson();
  }
  return data;
  }
}

class Two {
int? payTypeId;
String? payTypeCode;
String? payTypeDispCode;
String? imagePath;
SubTypeMap? subTypeMap;
SubTypeMap? payAccReqMap;
SubTypeMap? payAccKycType;
SubTypeMapPortal? subTypeMapPortal;
ProviderMap? providerMap;
CurrencyMap? currencyMap;
int? uiOrder;
double? minValue;
double? maxValue;

Two({this.payTypeId, this.payTypeCode, this.payTypeDispCode, this.imagePath, this.subTypeMap, this.payAccReqMap, this.payAccKycType, this.subTypeMapPortal, this.providerMap, this.currencyMap, this.uiOrder, this.minValue, this.maxValue});

Two.fromJson(Map<String, dynamic> json) {
payTypeId = json['payTypeId'];
payTypeCode = json['payTypeCode'];
payTypeDispCode = json['payTypeDispCode'];
imagePath = json['imagePath'];
subTypeMap = json['subTypeMap'] != null ?  SubTypeMap.fromJson(json['subTypeMap']) : null;
payAccReqMap = json['payAccReqMap'] != null ?  SubTypeMap.fromJson(json['payAccReqMap']) : null;
payAccKycType = json['payAccKycType'] != null ?  SubTypeMap.fromJson(json['payAccKycType']) : null;
subTypeMapPortal = json['subTypeMapPortal'] != null ?  SubTypeMapPortal.fromJson(json['subTypeMapPortal']) : null;
providerMap = json['providerMap'] != null ?  ProviderMap.fromJson(json['providerMap']) : null;
currencyMap = json['currencyMap'] != null ?  CurrencyMap.fromJson(json['currencyMap']) : null;
uiOrder = json['uiOrder'];
minValue = json['minValue'];
maxValue = json['maxValue'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data =  Map<String, dynamic>();
data['payTypeId'] = this.payTypeId;
data['payTypeCode'] = this.payTypeCode;
data['payTypeDispCode'] = this.payTypeDispCode;
data['imagePath'] = this.imagePath;
if (this.subTypeMap != null) {
data['subTypeMap'] = this.subTypeMap?.toJson();
}
if (this.payAccReqMap != null) {
data['payAccReqMap'] = this.payAccReqMap?.toJson();
}
if (this.payAccKycType != null) {
data['payAccKycType'] = this.payAccKycType?.toJson();
}
if (this.subTypeMapPortal != null) {
data['subTypeMapPortal'] = this.subTypeMapPortal?.toJson();
}
if (this.providerMap != null) {
data['providerMap'] = this.providerMap?.toJson();
}
if (this.currencyMap != null) {
data['currencyMap'] = this.currencyMap?.toJson();
}
data['uiOrder'] = this.uiOrder;
data['minValue'] = this.minValue;
data['maxValue'] = this.maxValue;
return data;
}
}

class SubTypeMap {
String? s5;

SubTypeMap({required this.s5});

SubTypeMap.fromJson(Map<String, dynamic> json) {
s5 = json['5'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data =  Map<String, dynamic>();
data['5'] = this.s5;
return data;
}
}

class SubTypeMapPortal {
String? map;
SubTypeMapPortal({this.map});

SubTypeMapPortal.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data =  Map<String, dynamic>();
return data;
}
}

class ProviderMap {
String? s1;

ProviderMap({this.s1});

ProviderMap.fromJson(Map<String, dynamic> json) {
s1 = json['1'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data =  Map<String, dynamic>();
data['1'] = this.s1;
return data;
}
}

class CurrencyMap {
String? s19;

CurrencyMap({this.s19});

CurrencyMap.fromJson(Map<String, dynamic> json) {
s19 = json['19'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data =  Map<String, dynamic>();
data['19'] = this.s19;
return data;
}
}