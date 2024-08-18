class GameInfoModel {
  int? errorCode;
  String? message;
  Data? data;

  GameInfoModel(
      {required this.errorCode, required this.message, required this.data});

  GameInfoModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  Games? games;
  ServerTime? serverTime;

  Data({required this.games, required this.serverTime});

  Data.fromJson(Map<String, dynamic> json) {
    games = json['games'] != null ? Games.fromJson(json['games']) : null;
    serverTime = json['serverTime'] != null
        ? ServerTime.fromJson(json['serverTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (games != null) {
      data['games'] = games?.toJson();
    }
    if (serverTime != null) {
      data['serverTime'] = serverTime?.toJson();
    }
    return data;
  }
}

class Games {
  DAILYLOTTO? dAILYLOTTO;

  Games({required this.dAILYLOTTO});

  Games.fromJson(Map<String, dynamic> json) {
    dAILYLOTTO = json['DAILYLOTTO'] != null
        ? DAILYLOTTO.fromJson(json['DAILYLOTTO'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dAILYLOTTO != null) {
      data['DAILYLOTTO'] = dAILYLOTTO?.toJson();
    }
    return data;
  }
}

class DAILYLOTTO {
  String? gameCode;
  String? datetime;
  String? estimatedJackpot;
  String? guaranteedJackpot;
  String? jackpotTitle;
  String? jackpotAmount;
  String? drawDate;
  List<Donation>? donation;
  Content? content;
  String? nextDrawDate;
  String? active;

  DAILYLOTTO(
      {required this.gameCode,
      required this.datetime,
      required this.estimatedJackpot,
      required this.guaranteedJackpot,
      required this.jackpotTitle,
      required this.jackpotAmount,
      required this.drawDate,
      required this.donation,
      required this.content,
      required this.nextDrawDate,
      required this.active});

  DAILYLOTTO.fromJson(Map<String, dynamic> json) {
    gameCode = json['game_code'];
    datetime = json['datetime'];
    estimatedJackpot = json['estimated_jackpot'];
    guaranteedJackpot = json['guaranteed_jackpot'];
    jackpotTitle = json['jackpot_title'];
    jackpotAmount = json['jackpot_amount'];
    drawDate = json['draw_date'];
    if (json['donation'] != null) {
      // donation = List<Donation>();
      donation = List.filled(0, Donation.fromJson(json), growable: true);
      json['donation'].forEach((v) {
        donation?.add(Donation.fromJson(v));
      });
    }
    content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
    nextDrawDate = json['next_draw_date'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['game_code'] = gameCode;
    data['datetime'] = datetime;
    data['estimated_jackpot'] = estimatedJackpot;
    data['guaranteed_jackpot'] = guaranteedJackpot;
    data['jackpot_title'] = jackpotTitle;
    data['jackpot_amount'] = jackpotAmount;
    data['draw_date'] = drawDate;
    if (donation != null) {
      data['donation'] = donation?.map((v) => v.toJson()).toList();
    }
    if (content != null) {
      data['content'] = content?.toJson();
    }
    data['next_draw_date'] = nextDrawDate;
    data['active'] = active;
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

class Content {
  int? currentDrawNumber;
  String? currentDrawFreezeDate;
  String? currentDrawStopTime;
  int? jackpotAmount;
  List<UnitCostJson>? unitCostJson;

  Content(
      {required this.currentDrawNumber,
      this.currentDrawFreezeDate,
      this.currentDrawStopTime,
      this.jackpotAmount,
      this.unitCostJson});

  Content.fromJson(Map<String, dynamic> json) {
    currentDrawNumber = json['currentDrawNumber'];
    currentDrawFreezeDate = json['currentDrawFreezeDate'];
    currentDrawStopTime = json['currentDrawStopTime'];
    jackpotAmount = json['jackpotAmount'];
    if (json['unitCostJson'] != null) {
      // unitCostJson = List<UnitCostJson>();
      unitCostJson =
          List.filled(0, UnitCostJson.fromJson(json), growable: true);
      json['unitCostJson'].forEach((v) {
        unitCostJson?.add(UnitCostJson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentDrawNumber'] = currentDrawNumber;
    data['currentDrawFreezeDate'] = currentDrawFreezeDate;
    data['currentDrawStopTime'] = currentDrawStopTime;
    data['jackpotAmount'] = jackpotAmount;
    if (unitCostJson != null) {
      data['unitCostJson'] = unitCostJson?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnitCostJson {
  String? currency;
  int? price;

  UnitCostJson({required this.currency, required this.price});

  UnitCostJson.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currency'] = currency;
    data['price'] = price;
    return data;
  }
}

class ServerTime {
  String? date;
  int? timezoneType;
  String? timezone;

  ServerTime(
      {required this.date, required this.timezoneType, required this.timezone});

  ServerTime.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['timezone_type'] = timezoneType;
    data['timezone'] = timezone;
    return data;
  }
}
