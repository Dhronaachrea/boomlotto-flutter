
import 'package:boom_lotto/src/data/model/transaction_list_model.dart';

abstract class TransactionListState {}

class TransactionListInitial extends TransactionListState {}

class TransactionListError extends TransactionListState {
  final String error;

  TransactionListError({required this.error});
}

class TransactionListLoadining extends TransactionListState {}

class TransactionListLoadedData extends TransactionListState {}

class TransactionListLoaded extends TransactionListState {
  var transactionListModel;
  TransactionListLoaded({required this.transactionListModel});
}
