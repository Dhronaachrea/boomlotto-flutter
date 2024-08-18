class SignUpModel {
  int? firstDepositCampTrackId;
  Mapping? mapping;
  String? domainName;
  String? firstDepositReferSource;
  PlayerLoginInfo? playerLoginInfo;
  String? rummyDeepLink;
  int? firstDepositReferSourceId;
  String? profileStatus;
  int? errorCode;
  int? firstDepositSubSourceId;
  RamPlayerInfo? ramPlayerInfo;
  String? playerToken;

  SignUpModel(
      {required this.firstDepositCampTrackId,
      required this.mapping,
      required this.domainName,
      required this.firstDepositReferSource,
      required this.playerLoginInfo,
      required this.rummyDeepLink,
      required this.firstDepositReferSourceId,
      required this.profileStatus,
      required this.errorCode,
      required this.firstDepositSubSourceId,
      required this.ramPlayerInfo,
      required this.playerToken});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    firstDepositCampTrackId = json['firstDepositCampTrackId'];
    mapping =
        json['mapping'] != null ? Mapping.fromJson(json['mapping']) : null;
    domainName = json['domainName'];
    firstDepositReferSource = json['firstDepositReferSource'];
    playerLoginInfo = json['playerLoginInfo'] != null
        ? PlayerLoginInfo.fromJson(json['playerLoginInfo'])
        : null;
    rummyDeepLink = json['rummyDeepLink'];
    firstDepositReferSourceId = json['firstDepositReferSourceId'];
    profileStatus = json['profileStatus'];
    errorCode = json['errorCode'];
    firstDepositSubSourceId = json['firstDepositSubSourceId'];
    ramPlayerInfo = json['ramPlayerInfo'] != null
        ? RamPlayerInfo.fromJson(json['ramPlayerInfo'])
        : null;
    playerToken = json['playerToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstDepositCampTrackId'] = firstDepositCampTrackId;
    if (mapping != null) {
      data['mapping'] = mapping!.toJson();
    }
    data['domainName'] = domainName;
    data['firstDepositReferSource'] = firstDepositReferSource;
    if (playerLoginInfo != null) {
      data['playerLoginInfo'] = playerLoginInfo!.toJson();
    }
    data['rummyDeepLink'] = rummyDeepLink;
    data['firstDepositReferSourceId'] = firstDepositReferSourceId;
    data['profileStatus'] = profileStatus;
    data['errorCode'] = errorCode;
    data['firstDepositSubSourceId'] = firstDepositSubSourceId;
    if (ramPlayerInfo != null) {
      data['ramPlayerInfo'] = ramPlayerInfo!.toJson();
    }
    data['playerToken'] = playerToken;
    return data;
  }
}

class Mapping {
  Mapping.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class PlayerLoginInfo {
  int? unreadMsgCount;
  String? country;
  WalletBean? walletBean;
  String? autoPassword;
  String? regDevice;
  String? isSmsService;
  String? ageVerified;
  String? lastLoginDate;
  String? firstLoginDate;
  String? communicationCharge;
  String? countryCode;
  String? playerType;
  String? registrationDate;
  String? state;
  String? playerStatus;
  String? referSource;
  String? addressVerified;
  int? playerId;
  int? affilateId;
  String? referFriendCode;
  String? phoneVerified;
  String? avatarPath;
  String? mobileNo;
  String? userName;
  String? registrationIp;
  String? olaPlayer;
  String? lastLoginIP;
  String? isPlay2x;
  String? emailVerified;
  String? commonContentPath;
  String? isEmailService;
  String? firstDepositDate;

  PlayerLoginInfo(
      {required this.unreadMsgCount,
      required this.country,
      required this.walletBean,
      required this.autoPassword,
      required this.regDevice,
      required this.isSmsService,
      required this.ageVerified,
      required this.lastLoginDate,
      required this.firstLoginDate,
      required this.communicationCharge,
      required this.countryCode,
      required this.playerType,
      required this.registrationDate,
      required this.state,
      required this.playerStatus,
      required this.referSource,
      required this.addressVerified,
      required this.playerId,
      required this.affilateId,
      required this.referFriendCode,
      required this.phoneVerified,
      required this.avatarPath,
      required this.mobileNo,
      required this.userName,
      required this.registrationIp,
      required this.olaPlayer,
      required this.lastLoginIP,
      required this.isPlay2x,
      required this.emailVerified,
      required this.commonContentPath,
      required this.isEmailService,
      required this.firstDepositDate});

  PlayerLoginInfo.fromJson(Map<String, dynamic> json) {
    unreadMsgCount = json['unreadMsgCount'];
    country = json['country'];
    walletBean = json['walletBean'] != null
        ? WalletBean.fromJson(json['walletBean'])
        : null;
    autoPassword = json['autoPassword'];
    regDevice = json['regDevice'];
    isSmsService = json['isSmsService'];
    ageVerified = json['ageVerified'];
    lastLoginDate = json['lastLoginDate'];
    firstLoginDate = json['firstLoginDate'];
    communicationCharge = json['communicationCharge'];
    countryCode = json['countryCode'];
    playerType = json['playerType'];
    registrationDate = json['registrationDate'];
    state = json['state'];
    playerStatus = json['playerStatus'];
    referSource = json['referSource'];
    addressVerified = json['addressVerified'];
    playerId = json['playerId'];
    affilateId = json['affilateId'];
    referFriendCode = json['referFriendCode'];
    phoneVerified = json['phoneVerified'];
    avatarPath = json['avatarPath'];
    mobileNo = json['mobileNo'];
    userName = json['userName'];
    registrationIp = json['registrationIp'];
    olaPlayer = json['olaPlayer'];
    lastLoginIP = json['lastLoginIP'];
    isPlay2x = json['isPlay2x'];
    emailVerified = json['emailVerified'];
    commonContentPath = json['commonContentPath'];
    isEmailService = json['isEmailService'];
    firstDepositDate = json['firstDepositDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unreadMsgCount'] = unreadMsgCount;
    data['country'] = country;
    if (walletBean != null) {
      data['walletBean'] = walletBean!.toJson();
    }
    data['autoPassword'] = autoPassword;
    data['regDevice'] = regDevice;
    data['isSmsService'] = isSmsService;
    data['ageVerified'] = ageVerified;
    data['lastLoginDate'] = lastLoginDate;
    data['firstLoginDate'] = firstLoginDate;
    data['communicationCharge'] = communicationCharge;
    data['countryCode'] = countryCode;
    data['playerType'] = playerType;
    data['registrationDate'] = registrationDate;
    data['state'] = state;
    data['playerStatus'] = playerStatus;
    data['referSource'] = referSource;
    data['addressVerified'] = addressVerified;
    data['playerId'] = playerId;
    data['affilateId'] = affilateId;
    data['referFriendCode'] = referFriendCode;
    data['phoneVerified'] = phoneVerified;
    data['avatarPath'] = avatarPath;
    data['mobileNo'] = mobileNo;
    data['userName'] = userName;
    data['registrationIp'] = registrationIp;
    data['olaPlayer'] = olaPlayer;
    data['lastLoginIP'] = lastLoginIP;
    data['isPlay2x'] = isPlay2x;
    data['emailVerified'] = emailVerified;
    data['commonContentPath'] = commonContentPath;
    data['isEmailService'] = isEmailService;
    data['firstDepositDate'] = firstDepositDate;
    return data;
  }
}

class WalletBean {
  double? totalBalance;
  double? cashBalance;
  double? depositBalance;
  double? winningBalance;
  double? bonusBalance;
  double? withdrawableBal;
  double? practiceBalance;
  String? currency;
  String? preferredWallet;
  double? totalDepositBalance;
  double? totalWithdrawableBalance;

  WalletBean(
      {required this.totalBalance,
      required this.cashBalance,
      required this.depositBalance,
      required this.winningBalance,
      required this.bonusBalance,
      required this.withdrawableBal,
      required this.practiceBalance,
      required this.currency,
      required this.preferredWallet,
      required this.totalDepositBalance,
      required this.totalWithdrawableBalance});

  WalletBean.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    cashBalance = json['cashBalance'];
    depositBalance = json['depositBalance'];
    winningBalance = json['winningBalance'];
    bonusBalance = json['bonusBalance'];
    withdrawableBal = json['withdrawableBal'];
    practiceBalance = json['practiceBalance'];
    currency = json['currency'];
    preferredWallet = json['preferredWallet'];
    totalDepositBalance = json['totalDepositBalance'];
    totalWithdrawableBalance = json['totalWithdrawableBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBalance'] = totalBalance;
    data['cashBalance'] = cashBalance;
    data['depositBalance'] = depositBalance;
    data['winningBalance'] = winningBalance;
    data['bonusBalance'] = bonusBalance;
    data['withdrawableBal'] = withdrawableBal;
    data['practiceBalance'] = practiceBalance;
    data['currency'] = currency;
    data['preferredWallet'] = preferredWallet;
    data['totalDepositBalance'] = totalDepositBalance;
    data['totalWithdrawableBalance'] = totalWithdrawableBalance;
    return data;
  }
}

class RamPlayerInfo {
  int? id;
  int? merchantId;
  int? domainId;
  int? playerId;
  String? addressVerified;
  String? nameVerified;
  String? emailVerified;
  String? mobileVerified;
  String? ageVerified;
  String? taxationIdVerified;
  String? securityQuestionVerified;
  String? idVerified;
  String? bankVerified;
  String? addressVerifiedAt;
  String? profileStatus;
  String? emailVerifiedAt;
  String? mobileVerifiedAt;
  String? ageVerifiedAt;
  String? taxationIdVerifiedAt;
  String? securityQuestionVerifiedAt;
  String? idVerifiedAt;
  String? bankVerifiedAt;
  String? createdAt;
  String? updatedAt;
  var profileExpiredAt;
  String? docUploaded;
  var uploadPendingDate;
  var verifiedBy;
  var verificationAssignAt;
  var verificationModeAt;

  RamPlayerInfo(
      {required this.id,
      required this.merchantId,
      required this.domainId,
      required this.playerId,
      required this.addressVerified,
      required this.nameVerified,
      required this.emailVerified,
      required this.mobileVerified,
      required this.ageVerified,
      required this.taxationIdVerified,
      required this.securityQuestionVerified,
      required this.idVerified,
      required this.bankVerified,
      required this.addressVerifiedAt,
      required this.profileStatus,
      required this.emailVerifiedAt,
      required this.mobileVerifiedAt,
      required this.ageVerifiedAt,
      required this.taxationIdVerifiedAt,
      required this.securityQuestionVerifiedAt,
      required this.idVerifiedAt,
      required this.bankVerifiedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.profileExpiredAt,
      required this.docUploaded,
      required this.uploadPendingDate,
      required this.verifiedBy,
      required this.verificationAssignAt,
      required this.verificationModeAt});

  RamPlayerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchantId'];
    domainId = json['domainId'];
    playerId = json['playerId'];
    addressVerified = json['addressVerified'];
    nameVerified = json['nameVerified'];
    emailVerified = json['emailVerified'];
    mobileVerified = json['mobileVerified'];
    ageVerified = json['ageVerified'];
    taxationIdVerified = json['taxationIdVerified'];
    securityQuestionVerified = json['securityQuestionVerified'];
    idVerified = json['idVerified'];
    bankVerified = json['bankVerified'];
    addressVerifiedAt = json['addressVerifiedAt'];
    profileStatus = json['profileStatus'];
    emailVerifiedAt = json['emailVerifiedAt'];
    mobileVerifiedAt = json['mobileVerifiedAt'];
    ageVerifiedAt = json['ageVerifiedAt'];
    taxationIdVerifiedAt = json['taxationIdVerifiedAt'];
    securityQuestionVerifiedAt = json['securityQuestionVerifiedAt'];
    idVerifiedAt = json['idVerifiedAt'];
    bankVerifiedAt = json['bankVerifiedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    profileExpiredAt = json['profileExpiredAt'];
    docUploaded = json['docUploaded'];
    uploadPendingDate = json['uploadPendingDate'];
    verifiedBy = json['verifiedBy'];
    verificationAssignAt = json['verificationAssignAt'];
    verificationModeAt = json['verificationModeAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchantId'] = merchantId;
    data['domainId'] = domainId;
    data['playerId'] = playerId;
    data['addressVerified'] = addressVerified;
    data['nameVerified'] = nameVerified;
    data['emailVerified'] = emailVerified;
    data['mobileVerified'] = mobileVerified;
    data['ageVerified'] = ageVerified;
    data['taxationIdVerified'] = taxationIdVerified;
    data['securityQuestionVerified'] = securityQuestionVerified;
    data['idVerified'] = idVerified;
    data['bankVerified'] = bankVerified;
    data['addressVerifiedAt'] = addressVerifiedAt;
    data['profileStatus'] = profileStatus;
    data['emailVerifiedAt'] = emailVerifiedAt;
    data['mobileVerifiedAt'] = mobileVerifiedAt;
    data['ageVerifiedAt'] = ageVerifiedAt;
    data['taxationIdVerifiedAt'] = taxationIdVerifiedAt;
    data['securityQuestionVerifiedAt'] = securityQuestionVerifiedAt;
    data['idVerifiedAt'] = idVerifiedAt;
    data['bankVerifiedAt'] = bankVerifiedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['profileExpiredAt'] = profileExpiredAt;
    data['docUploaded'] = docUploaded;
    data['uploadPendingDate'] = uploadPendingDate;
    data['verifiedBy'] = verifiedBy;
    data['verificationAssignAt'] = verificationAssignAt;
    data['verificationModeAt'] = verificationModeAt;
    return data;
  }
}
