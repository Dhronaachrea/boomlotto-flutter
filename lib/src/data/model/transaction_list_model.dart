class TransactionListModel {
  int? errorCode;
  List<TxnList>? txnList;
  String? openingBalanceDate;

  TransactionListModel({this.errorCode, this.txnList, this.openingBalanceDate});

  TransactionListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    if (json['txnList'] != null) {
      txnList = new List.filled(0, TxnList.fromJson(json),growable: true);
      json['txnList'].forEach((v) {
        txnList!.add(new TxnList.fromJson(v));
      });
    }
    openingBalanceDate = json['openingBalanceDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    if (this.txnList != null) {
      data['txnList'] = this.txnList!.map((v) => v.toJson()).toList();
    }
    data['openingBalanceDate'] = this.openingBalanceDate;
    return data;
  }
}

class TxnList {
  var transactionId;
  var transactionDate;
  var particular;
  var txnType;
  var currencyId;
  var creditAmount;
  var txnAmount;
  var balance;
  var openingBalance;
  var subwalletTxn;
  var currency;
  var withdrawableBalance;
  var gameGroup;
  var debitAmount;

  TxnList(
      {this.transactionId,
        this.transactionDate,
        this.particular,
        this.txnType,
        this.currencyId,
        this.creditAmount,
        this.txnAmount,
        this.balance,
        this.openingBalance,
        this.subwalletTxn,
        this.currency,
        this.withdrawableBalance,
        this.gameGroup,
        this.debitAmount});

  TxnList.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    transactionDate = json['transactionDate'];
    particular = json['particular'];
    txnType = json['txnType'];
    currencyId = json['currencyId'];
    creditAmount = json['creditAmount'];
    txnAmount = json['txnAmount'];
    balance = json['balance'];
    openingBalance = json['openingBalance'];
    subwalletTxn = json['subwalletTxn'];
    currency = json['currency'];
    withdrawableBalance = json['withdrawableBalance'];
    gameGroup = json['gameGroup'];
    debitAmount = json['debitAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['transactionDate'] = this.transactionDate;
    data['particular'] = this.particular;
    data['txnType'] = this.txnType;
    data['currencyId'] = this.currencyId;
    data['creditAmount'] = this.creditAmount;
    data['txnAmount'] = this.txnAmount;
    data['balance'] = this.balance;
    data['openingBalance'] = this.openingBalance;
    data['subwalletTxn'] = this.subwalletTxn;
    data['currency'] = this.currency;
    data['withdrawableBalance'] = this.withdrawableBalance;
    data['gameGroup'] = this.gameGroup;
    data['debitAmount'] = this.debitAmount;
    return data;
  }
}