import '../../../../Models/MiniTruckDriver/AssignedOrdersDetailsModel.dart';

abstract class AssignedOrdersDetailsStates {}

class AssignedOrdersDetailsInitially extends AssignedOrdersDetailsStates {}

class AssignedOrdersDetailsLoading extends AssignedOrdersDetailsStates {}

class AssignedOrdersDetailsLoaded extends AssignedOrdersDetailsStates {
  final AssignedOrdersDetailsModel assignedOrdersDetails;

  AssignedOrdersDetailsLoaded(this.assignedOrdersDetails);
}

class AssignedOrdersDetailsFailure extends AssignedOrdersDetailsStates {
  final String error;

  AssignedOrdersDetailsFailure(this.error);
}
