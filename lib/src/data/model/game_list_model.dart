class GameListModel {
  bool? success;
  Data? data;

  GameListModel({required this.success, required this.data});

  GameListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  Ige? ige;
  String? ipAddress;

  Data({required this.ige, required this.ipAddress});

  Data.fromJson(Map<String, dynamic> json) {
    ige = json['ige'] != null ? Ige.fromJson(json['ige']) : null;
    ipAddress = json['ipAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ige != null) {
      data['ige'] = ige?.toJson();
    }
    data['ipAddress'] = ipAddress;
    return data;
  }
}

class Ige {
  Engines? engines;

  Ige({required engines});

  Ige.fromJson(Map<String, dynamic> json) {
    engines =
        json['engines'] != null ? Engines.fromJson(json['engines']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (engines != null) {
      data['engines'] = engines?.toJson();
    }
    return data;
  }
}

class Engines {
  DUBAI? dUBAI;

  Engines({required dUBAI});

  Engines.fromJson(Map<String, dynamic> json) {
    dUBAI = json['DUBAI'] != null ? DUBAI.fromJson(json['DUBAI']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dUBAI != null) {
      data['DUBAI'] = dUBAI?.toJson();
    }
    return data;
  }
}

class DUBAI {
  List<Games>? games;
  Params? params;

  DUBAI({required this.games, required this.params});

  DUBAI.fromJson(Map<String, dynamic> json) {
    if (json['games'] != null) {
      // games = List<Games>();
      games = List.filled(0, Games.fromJson(json), growable: true);
      json['games'].forEach((v) {
        games?.add(Games.fromJson(v));
      });
    }
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (games != null) {
      data['games'] = games?.map((v) => v.toJson()).toList();
    }
    if (params != null) {
      data['params'] = params?.toJson();
    }
    return data;
  }
}

class Games {
  LoaderImage? loaderImage;
  PrizeSchemes? prizeSchemes;
  int? orderId;
  String? imagePath;
  int? windowHeight;
  String? isHTML5;
  String? isKeyboard;
  String? gameCategory;
  String? gameName;
  int? gameNumber;
  String? gameVersion;
  String? gameDescription;
  String? currencyCode;
  int? windowWidth;
  String? isFlash;
  String? status;
  dynamic isImageGeneration;
  dynamic isTablet;
  dynamic gameWinUpto;
  String? jackpotStatus;
  dynamic bonusMultiplier;
  dynamic setId;
  dynamic setName;
  List<int>? betList;
  ProductInfo? productInfo;

  Games(
      {required this.loaderImage,
      required this.prizeSchemes,
      required this.orderId,
      required this.imagePath,
      required this.windowHeight,
      required this.isHTML5,
      required this.isKeyboard,
      required this.gameCategory,
      required this.gameName,
      required this.gameNumber,
      required this.gameVersion,
      required this.gameDescription,
      required this.currencyCode,
      required this.windowWidth,
      required this.isFlash,
      required this.status,
      required this.isImageGeneration,
      required this.isTablet,
      required this.gameWinUpto,
      required this.jackpotStatus,
      required this.bonusMultiplier,
      required this.setId,
      required this.setName,
      required this.betList,
      required this.productInfo});

  Games.fromJson(Map<String, dynamic> json) {
    loaderImage = json['loaderImage'] != null
        ? LoaderImage.fromJson(json['loaderImage'])
        : null;
    prizeSchemes = json['prizeSchemes'] != null
        ? PrizeSchemes.fromJson(json['prizeSchemes'])
        : null;
    orderId = json['orderId'];
    imagePath = json['imagePath'];
    windowHeight = json['windowHeight'];
    isHTML5 = json['isHTML5'];
    isKeyboard = json['isKeyboard'];
    gameCategory = json['gameCategory'];
    gameName = json['gameName'];
    gameNumber = json['gameNumber'];
    gameVersion = json['gameVersion'];
    gameDescription = json['gameDescription'];
    currencyCode = json['currencyCode'];
    windowWidth = json['windowWidth'];
    isFlash = json['isFlash'];
    status = json['status'];
    isImageGeneration = json['isImageGeneration'];
    isTablet = json['isTablet'];
    gameWinUpto = json['gameWinUpto'];
    jackpotStatus = json['jackpotStatus'];
    bonusMultiplier = json['bonusMultiplier'];
    setId = json['setId'];
    setName = json['setName'];
    betList =
        json['betList'] != null ? json['betList'].cast<int>() : json['betList'];
    productInfo = json['productInfo'] != null
        ? ProductInfo.fromJson(json['productInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loaderImage != null) {
      data['loaderImage'] = loaderImage?.toJson();
    }
    if (prizeSchemes != null) {
      data['prizeSchemes'] = prizeSchemes?.toJson();
    }
    data['orderId'] = orderId;
    data['imagePath'] = imagePath;
    data['windowHeight'] = windowHeight;
    data['isHTML5'] = isHTML5;
    data['isKeyboard'] = isKeyboard;
    data['gameCategory'] = gameCategory;
    data['gameName'] = gameName;
    data['gameNumber'] = gameNumber;
    data['gameVersion'] = gameVersion;
    data['gameDescription'] = gameDescription;
    data['currencyCode'] = currencyCode;
    data['windowWidth'] = windowWidth;
    data['isFlash'] = isFlash;
    data['status'] = status;
    data['isImageGeneration'] = isImageGeneration;
    data['isTablet'] = isTablet;
    data['gameWinUpto'] = gameWinUpto;
    data['jackpotStatus'] = jackpotStatus;
    data['bonusMultiplier'] = bonusMultiplier;
    data['setId'] = setId;
    data['setName'] = setName;
    data['betList'] = betList;
    if (productInfo != null) {
      data['productInfo'] = productInfo?.toJson();
    }
    return data;
  }
}

class LoaderImage {
  String? s960;
  String? s1777;

  LoaderImage({required this.s960, required this.s1777});

  LoaderImage.fromJson(Map<String, dynamic> json) {
    s960 = json['960'];
    s1777 = json['1777'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['960'] = s960;
    data['1777'] = s1777;
    return data;
  }
}

class PrizeSchemes {
  int? i2;
  int? i7;
  int? i9;
  int? i6;
  int? i3;
  int? i8;
  int? i5;
  int? i1;

  PrizeSchemes(
      {required this.i2,
      required this.i7,
      required this.i9,
      required this.i6,
      required this.i3,
      required this.i8,
      required this.i5,
      required this.i1});

  PrizeSchemes.fromJson(Map<String, dynamic> json) {
    i2 = json['2'];
    i7 = json['7'];
    i9 = json['9'];
    i6 = json['6'];
    i3 = json['3'];
    i8 = json['8'];
    i5 = json['5'];
    i1 = json['1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['2'] = i2;
    data['7'] = i7;
    data['9'] = i9;
    data['6'] = i6;
    data['3'] = i3;
    data['8'] = i8;
    data['5'] = i5;
    data['1'] = i1;
    return data;
  }
}

class ProductInfo {
  List<Donation>? donation;

  ProductInfo({required this.donation});

  ProductInfo.fromJson(Map<String, dynamic> json) {
    if (json['donation'] != null) {
      // donation = List<Donation>();
      donation = List.filled(0, Donation.fromJson(json), growable: true);
      json['donation'].forEach((v) {
        donation?.add(Donation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (donation != null) {
      data['donation'] = donation?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Donation {
  String? image;
  String? title;

  Donation({required this.image, required this.title});

  Donation.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    return data;
  }
}

class Params {
  String? root;
  String? repo;
  String? merchantCode;
  int? merchantKey;
  String? secureKey;
  String? domainName;
  String? lang;
  List<String>? currencyCode;
  String? vendorType;

  Params(
      {required this.root,
      required this.repo,
      required this.merchantCode,
      required this.merchantKey,
      required this.secureKey,
      required this.domainName,
      required this.lang,
      required this.currencyCode,
      required this.vendorType});

  Params.fromJson(Map<String, dynamic> json) {
    root = json['root'];
    repo = json['repo'];
    merchantCode = json['merchantCode'];
    merchantKey = json['merchantKey'];
    secureKey = json['secureKey'];
    domainName = json['domainName'];
    lang = json['lang'];
    currencyCode = json['currencyCode'].cast<String>();
    vendorType = json['vendorType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['root'] = root;
    data['repo'] = repo;
    data['merchantCode'] = merchantCode;
    data['merchantKey'] = merchantKey;
    data['secureKey'] = secureKey;
    data['domainName'] = domainName;
    data['lang'] = lang;
    data['currencyCode'] = currencyCode;
    data['vendorType'] = vendorType;
    return data;
  }
}
