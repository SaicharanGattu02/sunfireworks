import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/Auth/auth_repository.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/AssignedOrders/AssignedOrdersCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/AssignedOrders/AssignedOrdersRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/AssignedOrdersDetails/AssignedOrdersDetailsCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/AssignedOrdersDetails/AssignedOrdersDetailsRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/CarPolyline/CarPolylineCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/CarPolyline/CarPolylineRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/CustomerGenerateOTP/CustomerGenerateOtpCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/CustomerGenerateOTP/CustomerGenerateOtpRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/Payment/PaymentCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/Payment/PaymentRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/UpdateOrderStatus/UpdateOrderStatusCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/MiniTruckDriver/UpdateOrderStatus/UpdateOrderStatusRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/CarDriverOTP/CarDriverOTPRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DCMPolyline/DCMPolylineCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DCMPolyline/DCMPolylineRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverDetails/DriverDetailsCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverDetails/DriverDetailsRepo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/StockTransfer/stock_transfer_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/WayPointWiseBoxes/waypoint_wise_boxes_cubit.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/WayPointWiseBoxes/waypoint_wise_boxes_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/UserDetails/UserDetailsCubit.dart';
import 'package:sunfireworks/data/bloc/cubits/UserDetails/UserDetailsRepo.dart';
import '../data/bloc/internet_status/internet_status_bloc.dart';
import '../data/remote_data_source.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<DriverAssignmentRepo>(
      create: (context) => DriverAssignmentRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<AssignedOrdersRepo>(
      create: (context) => AssignedOrdersRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<AssignedOrdersDetailsRepo>(
      create: (context) => AssignedOrdersDetailsRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CustomerGenerateOtpRepo>(
      create: (context) => CustomerGenerateOtpRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<UpdateOrderStatusRepo>(
      create: (context) => UpdateOrderStatusRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<DriverDetailsRepo>(
      create: (context) => DriverDetailsRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<WaypointWiseBoxesRepo>(
      create: (context) => WaypointWiseBoxesRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<UserDetailsRepo>(
      create: (context) => UserDetailsRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CarDriverOTPRepo>(
      create: (context) => CarDriverOTPRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<StockTransferRepo>(
      create: (context) => StockTransferRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PaymentRepo>(
      create: (context) => PaymentRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CarPolylineRepo>(
      create: (context) => CarPolylineRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<DCMPolylineRepo>(
      create: (context) => DCMPolylineRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(context.read<AuthRepository>()),
    ),
    BlocProvider<DriverAssignmentCubit>(
      create: (context) =>
          DriverAssignmentCubit(context.read<DriverAssignmentRepo>()),
    ),
    BlocProvider<AssignedOrdersCubit>(
      create: (context) => AssignedOrdersCubit(context.read<AssignedOrdersRepo>()),
    ),
    BlocProvider<AssignedOrdersDetailsCubit>(
      create: (context) => AssignedOrdersDetailsCubit(context.read<AssignedOrdersDetailsRepo>()),
    ),
    BlocProvider<CustomerGenerateOtpCubit>(
      create: (context) => CustomerGenerateOtpCubit(context.read<CustomerGenerateOtpRepo>()),
    ),
    BlocProvider<UpdateOrderStatusCubit>(
      create: (context) => UpdateOrderStatusCubit(context.read<UpdateOrderStatusRepo>()),
    ),
    BlocProvider<DriverDetailsCubit>(
      create: (context) => DriverDetailsCubit(context.read<DriverDetailsRepo>()),
    ),
    BlocProvider<WaypointWiseBoxesCubit>(
      create: (context) => WaypointWiseBoxesCubit(context.read<WaypointWiseBoxesRepo>()),
    ),
    BlocProvider<UserDetailsCubit>(
      create: (context) => UserDetailsCubit(context.read<UserDetailsRepo>()),
    ),
    BlocProvider<CarDriverOTPCubit>(
      create: (context) => CarDriverOTPCubit(context.read<CarDriverOTPRepo>()),
    ),
    BlocProvider<StockTransferCubit>(
      create: (context) => StockTransferCubit(context.read<StockTransferRepo>()),
    ),
    BlocProvider<PaymentCubit>(
      create: (context) => PaymentCubit(context.read<PaymentRepo>()),
    ),
    BlocProvider<CarPolylineCubit>(
      create: (context) => CarPolylineCubit(context.read<CarPolylineRepo>()),
    ),
    BlocProvider<DCMPolylineCubit>(
      create: (context) => DCMPolylineCubit(context.read<DCMPolylineRepo>()),
    ),
  ];
}
