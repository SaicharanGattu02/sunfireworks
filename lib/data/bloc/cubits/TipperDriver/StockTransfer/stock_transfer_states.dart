import 'package:sunfireworks/data/Models/SuccessModel.dart';

abstract class StockTransferStates {}

class StockTransferInitially extends StockTransferStates {}

class StockTransferLoading extends StockTransferStates {}

class StockTransferLoaded extends StockTransferStates {
  SuccessModel successModel;
  StockTransferLoaded(this.successModel);
}

class StockTransferFailure extends StockTransferStates {
  String error;
  StockTransferFailure(this.error);
}
