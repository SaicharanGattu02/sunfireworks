class DriverAssignmentModel {
  bool? success;
  String? message;
  Data? data;

  DriverAssignmentModel({this.success, this.message, this.data});

  DriverAssignmentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? page;
  String? nextPage;
  String? prevPage;
  int? count;
  int? rowsPerPage;
  List<Results>? results;

  Data(
      {this.page,
        this.nextPage,
        this.prevPage,
        this.count,
        this.rowsPerPage,
        this.results});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    nextPage = json['next_page'];
    prevPage = json['prev_page'];
    count = json['count'];
    rowsPerPage = json['rows_per_page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['next_page'] = this.nextPage;
    data['prev_page'] = this.prevPage;
    data['count'] = this.count;
    data['rows_per_page'] = this.rowsPerPage;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? id;
  DcmAssignment? dcmAssignment;
  List<dynamic>? bags;
  List<IndividualItems>? individualItems;
  List<dynamic>? comboItems;
  String? wayPoint;
  String? wayPointName;
  List<AssignedCars>? assignedCars;
  int? noOfVehicles;
  String? selectedPoints;
  int? radiusKm;
  bool? isActive;
  List<dynamic>? extraBags;
  List<dynamic>? extraIndividualItems;
  List<dynamic>? extraComboItems;
  dynamic? distance;
  int? boxes_count;
  int? extra_boxes_count;

  Results(
      {this.id,
        this.dcmAssignment,
        this.bags,
        this.individualItems,
        this.comboItems,
        this.wayPoint,
        this.wayPointName,
        this.assignedCars,
        this.noOfVehicles,
        this.selectedPoints,
        this.radiusKm,
        this.isActive,
        this.extraBags,
        this.extraIndividualItems,
        this.extraComboItems,
        this.boxes_count,
        this.extra_boxes_count,
        this.distance});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dcmAssignment = json['dcm_assignment'] != null
        ? new DcmAssignment.fromJson(json['dcm_assignment'])
        : null;
    // if (json['bags'] != null) {
    //   bags = <Null>[];
    //   json['bags'].forEach((v) {
    //     bags!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['individual_items'] != null) {
      individualItems = <IndividualItems>[];
      json['individual_items'].forEach((v) {
        individualItems!.add(new IndividualItems.fromJson(v));
      });
    }
    // if (json['combo_items'] != null) {
    //   comboItems = <Null>[];
    //   json['combo_items'].forEach((v) {
    //     comboItems!.add(new Null.fromJson(v));
    //   });
    // }
    wayPoint = json['way_point'];
    wayPointName = json['way_point_name'];
    if (json['assigned_cars'] != null) {
      assignedCars = <AssignedCars>[];
      json['assigned_cars'].forEach((v) {
        assignedCars!.add(new AssignedCars.fromJson(v));
      });
    }
    noOfVehicles = json['no_of_vehicles'];
    selectedPoints = json['selected_points'];
    radiusKm = json['radius_km'];
    isActive = json['is_active'];
    // if (json['extra_bags'] != null) {
    //   extraBags = <Null>[];
    //   json['extra_bags'].forEach((v) {
    //     extraBags!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['extra_individual_items'] != null) {
    //   extraIndividualItems = <Null>[];
    //   json['extra_individual_items'].forEach((v) {
    //     extraIndividualItems!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['extra_combo_items'] != null) {
    //   extraComboItems = <Null>[];
    //   json['extra_combo_items'].forEach((v) {
    //     extraComboItems!.add(new Null.fromJson(v));
    //   });
    // }
    distance = json['distance'];
    boxes_count = json['boxes_count'];
    extra_boxes_count = json['extra_boxes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.dcmAssignment != null) {
      data['dcm_assignment'] = this.dcmAssignment!.toJson();
    }
    if (this.bags != null) {
      data['bags'] = this.bags!.map((v) => v.toJson()).toList();
    }
    if (this.individualItems != null) {
      data['individual_items'] =
          this.individualItems!.map((v) => v.toJson()).toList();
    }
    if (this.comboItems != null) {
      data['combo_items'] = this.comboItems!.map((v) => v.toJson()).toList();
    }
    data['way_point'] = this.wayPoint;
    data['way_point_name'] = this.wayPointName;
    if (this.assignedCars != null) {
      data['assigned_cars'] =
          this.assignedCars!.map((v) => v.toJson()).toList();
    }
    data['no_of_vehicles'] = this.noOfVehicles;
    data['selected_points'] = this.selectedPoints;
    data['radius_km'] = this.radiusKm;
    data['is_active'] = this.isActive;
    if (this.extraBags != null) {
      data['extra_bags'] = this.extraBags!.map((v) => v.toJson()).toList();
    }
    if (this.extraIndividualItems != null) {
      data['extra_individual_items'] =
          this.extraIndividualItems!.map((v) => v.toJson()).toList();
    }
    if (this.extraComboItems != null) {
      data['extra_combo_items'] =
          this.extraComboItems!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    data['boxes_count'] = this.boxes_count;
    data['extra_boxes_count'] = this.extra_boxes_count;
    return data;
  }
}

class DcmAssignment {
  String? id;
  String? assignmentId;
  String? dcmVehicle;
  String? warehouse;
  String? startPoint;
  String? status;

  DcmAssignment(
      {this.id,
        this.assignmentId,
        this.dcmVehicle,
        this.warehouse,
        this.startPoint,
        this.status});

  DcmAssignment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    assignmentId = json['assignment_id'];
    dcmVehicle = json['dcm_vehicle'];
    warehouse = json['warehouse'];
    startPoint = json['start_point'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['assignment_id'] = this.assignmentId;
    data['dcm_vehicle'] = this.dcmVehicle;
    data['warehouse'] = this.warehouse;
    data['start_point'] = this.startPoint;
    data['status'] = this.status;
    return data;
  }
}

class IndividualItems {
  String? id;
  bool? isActive;
  String? code;
  String? individual;
  String? individualName;
  String? warehouseName;
  String? qrCode;

  IndividualItems(
      {this.id,
        this.isActive,
        this.code,
        this.individual,
        this.individualName,
        this.warehouseName,
        this.qrCode});

  IndividualItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
    code = json['code'];
    individual = json['individual'];
    individualName = json['individual_name'];
    warehouseName = json['warehouse_name'];
    qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    data['code'] = this.code;
    data['individual'] = this.individual;
    data['individual_name'] = this.individualName;
    data['warehouse_name'] = this.warehouseName;
    data['qr_code'] = this.qrCode;
    return data;
  }
}

class AssignedCars {
  String? id;
  String? carLocation;
  int? ordersCount;
  int? radius;
  String? startDateTime;
  String? endDateTime;
  String? status;
  Car? car;
  String? createdAt;

  AssignedCars(
      {this.id,
        this.carLocation,
        this.ordersCount,
        this.radius,
        this.startDateTime,
        this.endDateTime,
        this.status,
        this.car,
        this.createdAt});

  AssignedCars.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carLocation = json['car_location'];
    ordersCount = json['orders_count'];
    radius = json['radius'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    status = json['status'];
    car = json['car'] != null ? new Car.fromJson(json['car']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_location'] = this.carLocation;
    data['orders_count'] = this.ordersCount;
    data['radius'] = this.radius;
    data['start_date_time'] = this.startDateTime;
    data['end_date_time'] = this.endDateTime;
    data['status'] = this.status;
    if (this.car != null) {
      data['car'] = this.car!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Car {
  String? carId;
  String? vehicleNumber;
  String? driver;

  Car({this.carId, this.vehicleNumber, this.driver});

  Car.fromJson(Map<String, dynamic> json) {
    carId = json['car_id'];
    vehicleNumber = json['vehicle_number'];
    driver = json['driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_id'] = this.carId;
    data['vehicle_number'] = this.vehicleNumber;
    data['driver'] = this.driver;
    return data;
  }
}
