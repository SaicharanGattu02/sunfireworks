import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_states.dart';

class StockTransferCubit extends Cubit<StockTransferStates> {
  StockTransferRepo stockTransferRepo;
  StockTransferCubit(this.stockTransferRepo) : super(StockTransferInitially());

  Future<void> stockTransferApi(Map<String, dynamic> data) async{
    emit(StockTransferLoading());
    try{
      final response = await stockTransferRepo.stockTransferApi(data);
      if(response!=null && response.success==true){
        emit(StockTransferLoaded(response));
      }else{
        emit(StockTransferFailure(response?.message??""));
      }
    }catch(e){
      emit(StockTransferFailure(e.toString()));
    }
  }
}
