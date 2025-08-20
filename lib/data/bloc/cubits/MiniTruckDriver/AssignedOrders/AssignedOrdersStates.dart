import '../../../../Models/MiniTruckDriver/AssignedOrdersModel.dart';

abstract class AssignedOrdersStates {}

class AssignedOrdersInitially extends AssignedOrdersStates {}

class AssignedOrdersLoading extends AssignedOrdersStates {}

class AssignedOrdersLoaded extends AssignedOrdersStates {
  final AssignedOrdersModel assignedOrders;

  AssignedOrdersLoaded(this.assignedOrders);
}

class AssignedOrdersFailure extends AssignedOrdersStates {
  final String error;

  AssignedOrdersFailure(this.error);
}
