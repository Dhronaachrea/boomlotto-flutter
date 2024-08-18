class Todo {
  int? errorCode;
  String? message;
  Data? data;

  Todo({required this.errorCode, required this.message, required this.data});

  Todo.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errorCode'] = errorCode;
    data['message'] = message;
    data['data'] = this.data?.toJson();
    return data;
  }
}

class Data {
  List<HOME>? hOME;

  Data({required this.hOME});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['HOME'] != null) {
      // hOME = List<HOME>.filled(1, fill,growable: true);
      hOME = List<HOME>.filled(0, HOME.fromJson(json), growable: true);
      json['HOME'].forEach((v) {
        hOME?.add(HOME.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hOME != null) {
      data['HOME'] = hOME?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HOME {
  String? gameCode;
  String? title;
  String? imageItem;

  HOME({required this.gameCode, required this.title, required this.imageItem});

  HOME.fromJson(Map<String, dynamic> json) {
    gameCode = json['gameCode'];
    title = json['title'];
    imageItem = json['imageItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gameCode'] = gameCode;
    data['title'] = title;
    data['imageItem'] = imageItem;
    return data;
  }
}
