class DriverAssignmentModel {
  final bool success;
  final String message;
  final AssignmentData? data;

  DriverAssignmentModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory DriverAssignmentModel.fromJson(Map<String, dynamic> json) {
    return DriverAssignmentModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AssignmentData.fromJson(json['data']) : null,
    );
  }
}

class AssignmentData {
  final int page;
  final int? nextPage;
  final int? prevPage;
  final int count;
  final int rowsPerPage;
  final List<AssignmentResult> results;

  AssignmentData({
    required this.page,
    this.nextPage,
    this.prevPage,
    required this.count,
    required this.rowsPerPage,
    required this.results,
  });

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      page: json['page'] ?? 0,
      nextPage: json['next_page'],
      prevPage: json['prev_page'],
      count: json['count'] ?? 0,
      rowsPerPage: json['rows_per_page'] ?? 0,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => AssignmentResult.fromJson(e))
          .toList(),
    );
  }
}

class AssignmentResult {
  final String id;
  final DcmAssignment? dcmAssignment;
  final List<dynamic> bags;
  final List<dynamic> individualItems;
  final List<ComboItem> comboItems;
  final String? wayPoint;
  final String? wayPointName;
  final List<AssignedCar> assignedCars;
  final int noOfVehicles;
  final String? selectedPoints;
  final dynamic radiusKm;
  final bool isActive;
  final List<dynamic> extraBags;
  final List<dynamic> extraIndividualItems;
  final List<dynamic> extraComboItems;
  final dynamic distance;
  final int boxesCount;
  final int extraBoxesCount;

  AssignmentResult({
    required this.id,
    this.dcmAssignment,
    required this.bags,
    required this.individualItems,
    required this.comboItems,
    this.wayPoint,
    this.wayPointName,
    required this.assignedCars,
    required this.noOfVehicles,
    this.selectedPoints,
    this.radiusKm,
    required this.isActive,
    required this.extraBags,
    required this.extraIndividualItems,
    required this.extraComboItems,
    this.distance,
    required this.boxesCount,
    required this.extraBoxesCount,
  });

  factory AssignmentResult.fromJson(Map<String, dynamic> json) {
    return AssignmentResult(
      id: json['id'] ?? '',
      dcmAssignment: json['dcm_assignment'] != null
          ? DcmAssignment.fromJson(json['dcm_assignment'])
          : null,
      bags: json['bags'] ?? [],
      individualItems: json['individual_items'] ?? [],
      comboItems: (json['combo_items'] as List<dynamic>? ?? [])
          .map((e) => ComboItem.fromJson(e))
          .toList(),
      wayPoint: json['way_point'],
      wayPointName: json['way_point_name'],
      assignedCars: (json['assigned_cars'] as List<dynamic>? ?? [])
          .map((e) => AssignedCar.fromJson(e))
          .toList(),
      noOfVehicles: json['no_of_vehicles'] ?? 0,
      selectedPoints: json['selected_points'],
      radiusKm: json['radius_km'],
      isActive: json['is_active'] ?? false,
      extraBags: json['extra_bags'] ?? [],
      extraIndividualItems: json['extra_individual_items'] ?? [],
      extraComboItems: json['extra_combo_items'] ?? [],
      distance: json['distance'],
      boxesCount: json['boxes_count'] ?? 0,
      extraBoxesCount: json['extra_boxes_count'] ?? 0,
    );
  }
}

class DcmAssignment {
  final String id;
  final String assignmentId;
  final String dcmVehicle;
  final String warehouse;
  final String startPoint;
  final String status;

  DcmAssignment({
    required this.id,
    required this.assignmentId,
    required this.dcmVehicle,
    required this.warehouse,
    required this.startPoint,
    required this.status,
  });

  factory DcmAssignment.fromJson(Map<String, dynamic> json) {
    return DcmAssignment(
      id: json['id'] ?? '',
      assignmentId: json['assignment_id'] ?? '',
      dcmVehicle: json['dcm_vehicle'] ?? '',
      warehouse: json['warehouse'] ?? '',
      startPoint: json['start_point'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class ComboItem {
  final String id;
  final String combo;
  final String code;
  final String qrCode;

  ComboItem({
    required this.id,
    required this.combo,
    required this.code,
    required this.qrCode,
  });

  factory ComboItem.fromJson(Map<String, dynamic> json) {
    return ComboItem(
      id: json['id'] ?? '',
      combo: json['combo'] ?? '',
      code: json['code'] ?? '',
      qrCode: json['qr_code'] ?? '',
    );
  }
}

class AssignedCar {
  final String id;
  final String carLocation;
  final int ordersCount;
  final int? radius;
  final String startDateTime;
  final String endDateTime;
  final String status;
  final Car? car;
  final List<IndividualStockDetail> individualStockDetails;
  final List<ComboStockDetail> comboStockDetails;
  final String selectedPoint;
  final String createdAt;
  final List<dynamic> packStockDetails;

  AssignedCar({
    required this.id,
    required this.carLocation,
    required this.ordersCount,
    this.radius,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    this.car,
    required this.individualStockDetails,
    required this.comboStockDetails,
    required this.selectedPoint,
    required this.createdAt,
    required this.packStockDetails,
  });

  factory AssignedCar.fromJson(Map<String, dynamic> json) {
    return AssignedCar(
      id: json['id'] ?? '',
      carLocation: json['car_location'] ?? '',
      ordersCount: json['orders_count'] ?? 0,
      radius: json['radius'],
      startDateTime: json['start_date_time'] ?? '',
      endDateTime: json['end_date_time'] ?? '',
      status: json['status'] ?? '',
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      individualStockDetails:
      (json['individual_stock_details'] as List<dynamic>? ?? [])
          .map((e) => IndividualStockDetail.fromJson(e))
          .toList(),
      comboStockDetails: (json['combo_stock_details'] as List<dynamic>? ?? [])
          .map((e) => ComboStockDetail.fromJson(e))
          .toList(),
      selectedPoint: json['selected_point'] ?? '',
      createdAt: json['created_at'] ?? '',
      packStockDetails: json['pack_stock_details'] ?? [],
    );
  }
}

class Car {
  final String carId;
  final String vehicleNumber;
  final String driver;

  Car({
    required this.carId,
    required this.vehicleNumber,
    required this.driver,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: json['car_id'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      driver: json['driver'] ?? '',
    );
  }
}

class IndividualStockDetail {
  final String individualId;
  final String individualName;
  final int stockRequired;

  IndividualStockDetail({
    required this.individualId,
    required this.individualName,
    required this.stockRequired,
  });

  factory IndividualStockDetail.fromJson(Map<String, dynamic> json) {
    return IndividualStockDetail(
      individualId: json['individual_id'] ?? '',
      individualName: json['individual_name'] ?? '',
      stockRequired: json['stock_required'] ?? 0,
    );
  }
}

class ComboStockDetail {
  final String comboId;
  final String comboName;
  final int stockRequired;

  ComboStockDetail({
    required this.comboId,
    required this.comboName,
    required this.stockRequired,
  });

  factory ComboStockDetail.fromJson(Map<String, dynamic> json) {
    return ComboStockDetail(
      comboId: json['combo_id'] ?? '',
      comboName: json['combo_name'] ?? '',
      stockRequired: json['stock_required'] ?? 0,
    );
  }
}
