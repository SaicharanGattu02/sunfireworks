import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_states.dart';

class StockTransferCubit extends Cubit<StockTransferStates> {
  StockTransferRepo stockTransferRepo;
  StockTransferCubit(this.stockTransferRepo) : super(StockTransferInitially());
}
