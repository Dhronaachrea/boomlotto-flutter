import 'package:bloc/bloc.dart';
import 'package:boom_lotto/src/cubit/transaction_list_cubit/transaction_list_state.dart';
import 'package:boom_lotto/src/data/repository.dart';

class TransactionListCubit extends Cubit<TransactionListState>
{
  final Repository repository;
  TransactionListCubit({required this.repository}) : super(TransactionListInitial());

  void fetchTransactionList(Map<String, dynamic> request) {
    repository.fetchTransactionList(request).then((result) {
      emit(TransactionListLoaded(transactionListModel: result!.txnList));
    });
  }

  void fetchSearchTransactionList(List txnList) {
    // emit(TransactionListLoaded(transactionListModel: txnList));
    emit(TransactionListLoadedData());
  }
}
