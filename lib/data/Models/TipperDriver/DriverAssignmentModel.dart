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
    try {
      return DriverAssignmentModel(
        success: json['success'] ?? false,
        message: json['message']?.toString() ?? '',
        data: json['data'] != null ? AssignmentData.fromJson(json['data']) : null,
      );
    } catch (e) {
      print('Error parsing DriverAssignmentModel: $e');
      print('JSON: $json');
      rethrow;
    }
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
    try {
      return AssignmentData(
        page: json['page'] ?? 0,
        nextPage: json['next_page'],
        prevPage: json['prev_page'],
        count: json['count'] ?? 0,
        rowsPerPage: json['rows_per_page'] ?? 0,
        results: (json['results'] as List<dynamic>? ?? [])
            .asMap()
            .entries
            .map((entry) {
          try {
            return AssignmentResult.fromJson(entry.value);
          } catch (e) {
            print('Error parsing AssignmentResult at index ${entry.key}: $e');
            rethrow;
          }
        }).toList(),
      );
    } catch (e) {
      print('Error parsing AssignmentData: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class AssignmentResult {
  final String id;
  final DcmAssignment? dcmAssignment;
  final List<Bag> bags;
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
    try {
      return AssignmentResult(
        id: json['id']?.toString() ?? '',
        dcmAssignment: json['dcm_assignment'] != null
            ? DcmAssignment.fromJson(json['dcm_assignment'])
            : null,
        bags: (json['bags'] as List<dynamic>? ?? [])
            .map((e) => Bag.fromJson(e))
            .toList(),
        individualItems: json['individual_items'] ?? [],
        comboItems: (json['combo_items'] as List<dynamic>? ?? [])
            .map((e) => ComboItem.fromJson(e))
            .toList(),
        wayPoint: json['way_point']?.toString(),
        wayPointName: json['way_point_name']?.toString(),
        assignedCars: (json['assigned_cars'] as List<dynamic>? ?? [])
            .asMap()
            .entries
            .map((entry) {
          try {
            return AssignedCar.fromJson(entry.value);
          } catch (e) {
            print('Error parsing AssignedCar at index ${entry.key}: $e');
            rethrow;
          }
        }).toList(),
        noOfVehicles: json['no_of_vehicles'] ?? 0,
        selectedPoints: json['selected_points']?.toString(),
        radiusKm: json['radius_km'],
        isActive: json['is_active'] ?? false,
        extraBags: json['extra_bags'] ?? [],
        extraIndividualItems: json['extra_individual_items'] ?? [],
        extraComboItems: json['extra_combo_items'] ?? [],
        distance: json['distance'],
        boxesCount: json['boxes_count'] ?? 0,
        extraBoxesCount: json['extra_boxes_count'] ?? 0,
      );
    } catch (e) {
      print('Error parsing AssignmentResult: $e');
      print('JSON: $json');
      rethrow;
    }
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
    try {
      return DcmAssignment(
        id: json['id']?.toString() ?? '',
        assignmentId: json['assignment_id']?.toString() ?? '',
        dcmVehicle: json['dcm_vehicle']?.toString() ?? '',
        warehouse: json['warehouse']?.toString() ?? '',
        startPoint: json['start_point']?.toString() ?? '',
        status: json['status']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing DcmAssignment: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class Bag {
  final String id;
  final String code;
  final String qrCode;

  Bag({
    required this.id,
    required this.code,
    required this.qrCode,
  });

  factory Bag.fromJson(Map<String, dynamic> json) {
    try {
      return Bag(
        id: json['id']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        qrCode: json['qr_code']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing Bag: $e');
      print('JSON: $json');
      rethrow;
    }
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
    try {
      return ComboItem(
        id: json['id']?.toString() ?? '',
        combo: json['combo']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
        qrCode: json['qr_code']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing ComboItem: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class AssignedCar {
  final String id;
  final String carLocation;
  final int ordersCount;
  final int? radius;
  final double? distance;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final String status;
  final Car? car;
  final List<IndividualStockDetail> individualStockDetails;
  final List<ComboStockDetail> comboStockDetails;
  final String selectedPoint;
  final String createdAt;
  final List<Bag> bags;
  final List<PackItem> packItems;
  final List<dynamic> packStockDetails;
  final List<dynamic> extraBags;
  final List<dynamic> extraPackItems;

  AssignedCar({
    required this.id,
    required this.carLocation,
    required this.ordersCount,
    this.radius,
    this.distance,
    this.startDateTime,
    this.endDateTime,
    required this.status,
    this.car,
    required this.individualStockDetails,
    required this.comboStockDetails,
    required this.selectedPoint,
    required this.createdAt,
    required this.bags,
    required this.packItems,
    required this.packStockDetails,
    required this.extraBags,
    required this.extraPackItems,
  });

  factory AssignedCar.fromJson(Map<String, dynamic> json) {
    try {
      return AssignedCar(
        id: json['id']?.toString() ?? '',
        carLocation: json['car_location']?.toString() ?? '',
        ordersCount: json['orders_count'] ?? 0,
        radius: json['radius'],
        distance: (json['distance'] != null)
            ? (json['distance'] is int
            ? (json['distance'] as int).toDouble()
            : json['distance'] as double?)
            : null,
        startDateTime: json['start_date_time'] != null
            ? DateTime.tryParse(json['start_date_time']?.toString() ?? '')
            : null,
        endDateTime: json['end_date_time'] != null
            ? DateTime.tryParse(json['end_date_time']?.toString() ?? '')
            : null,
        status: json['status']?.toString() ?? '',
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        individualStockDetails: (json['individual_stock_details'] as List<dynamic>? ?? [])
            .asMap()
            .entries
            .map((entry) {
          try {
            return IndividualStockDetail.fromJson(entry.value);
          } catch (e) {
            print('Error parsing IndividualStockDetail at index ${entry.key}: $e');
            rethrow;
          }
        }).toList(),
        comboStockDetails: (json['combo_stock_details'] as List<dynamic>? ?? [])
            .asMap()
            .entries
            .map((entry) {
          try {
            return ComboStockDetail.fromJson(entry.value);
          } catch (e) {
            print('Error parsing ComboStockDetail at index ${entry.key}: $e');
            rethrow;
          }
        }).toList(),
        selectedPoint: json['selected_point']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? '',
        bags: (json['bags'] as List<dynamic>? ?? [])
            .map((e) => Bag.fromJson(e))
            .toList(),
        packItems: (json['pack_items'] as List<dynamic>? ?? [])
            .map((e) => PackItem.fromJson(e))
            .toList(),
        packStockDetails: json['pack_stock_details'] ?? [],
        extraBags: json['extra_bags'] ?? [],
        extraPackItems: json['extra_pack_items'] ?? [],
      );
    } catch (e) {
      print('Error parsing AssignedCar: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class Car {
  final String carId;
  final String vehicleNumber;
  final String driver;
  final String mobile;
  final String? company;
  final String? model;

  Car({
    required this.carId,
    required this.vehicleNumber,
    required this.driver,
    required this.mobile,
    this.company,
    this.model,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    try {
      return Car(
        carId: json['car_id']?.toString() ?? '',
        vehicleNumber: json['vehicle_number']?.toString() ?? '',
        driver: json['driver']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        company: json['company']?.toString(),
        model: json['model']?.toString(),
      );
    } catch (e) {
      print('Error parsing Car: $e');
      print('JSON: $json');
      rethrow;
    }
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
    try {
      return IndividualStockDetail(
        individualId: json['individual_id']?.toString() ?? '',
        individualName: json['individual_name']?.toString() ?? '',
        stockRequired: json['stock_required'] ?? 0,
      );
    } catch (e) {
      print('Error parsing IndividualStockDetail: $e');
      print('JSON: $json');
      rethrow;
    }
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
    try {
      return ComboStockDetail(
        comboId: json['combo_id']?.toString() ?? '',
        comboName: json['combo_name']?.toString() ?? '',
        stockRequired: json['stock_required'] ?? 0,
      );
    } catch (e) {
      print('Error parsing ComboStockDetail: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class PackItem {
  final String id;
  final PackOrder? order;
  final List<PackIndividualItem> individualItems;
  final List<dynamic> comboItems;
  final String qrCode;
  final String code;

  PackItem({
    required this.id,
    this.order,
    required this.individualItems,
    required this.comboItems,
    required this.qrCode,
    required this.code,
  });

  factory PackItem.fromJson(Map<String, dynamic> json) {
    try {
      return PackItem(
        id: json['id']?.toString() ?? '',
        order: json['order'] != null ? PackOrder.fromJson(json['order']) : null,
        individualItems: (json['individual_items'] as List<dynamic>? ?? [])
            .asMap()
            .entries
            .map((entry) {
          try {
            return PackIndividualItem.fromJson(entry.value);
          } catch (e) {
            print('Error parsing PackIndividualItem at index ${entry.key}: $e');
            rethrow;
          }
        }).toList(),
        comboItems: json['combo_items'] ?? [],
        qrCode: json['qr_code']?.toString() ?? '',
        code: json['code']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing PackItem: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class PackOrder {
  final String id;
  final String orderId;
  final String orderStatus;

  PackOrder({
    required this.id,
    required this.orderId,
    required this.orderStatus,
  });

  factory PackOrder.fromJson(Map<String, dynamic> json) {
    try {
      return PackOrder(
        id: json['id']?.toString() ?? '',
        orderId: json['order_id']?.toString() ?? '',
        orderStatus: json['order_status']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing PackOrder: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

class PackIndividualItem {
  final String id;
  final String name;

  PackIndividualItem({
    required this.id,
    required this.name,
  });

  factory PackIndividualItem.fromJson(Map<String, dynamic> json) {
    try {
      return PackIndividualItem(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing PackIndividualItem: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}