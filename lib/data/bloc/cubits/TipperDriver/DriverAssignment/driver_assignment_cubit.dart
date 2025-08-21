import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_repo.dart';
import 'package:sunfireworks/data/bloc/cubits/TipperDriver/DriverAssignment/driver_assignment_states.dart';

import '../../../../Models/TipperDriver/DriverAssignmentModel.dart';

class DriverAssignmentCubit extends Cubit<DriverAssignmentStates> {
  final DriverAssignmentRepo driverAssignmentRepo;
  DriverAssignmentCubit(this.driverAssignmentRepo)
      : super(DriverAssignmentInitially());

  DriverAssignmentModel driverAssignmentModel = DriverAssignmentModel();

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingMore = false;

  /// First page load
  Future<void> getDriverAssignments() async {
    emit(DriverAssignmentLoading());
    _currentPage = 1;
    try {
      final response = await driverAssignmentRepo.getDriverAssignments(
        _currentPage,
      );

      if (response != null && response.success == true) {
        driverAssignmentModel = response;
        _hasNextPage = response.data?.nextPage != null;
        emit(DriverAssignmentLoaded(driverAssignmentModel, _hasNextPage));
      } else {
        emit(DriverAssignmentFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(DriverAssignmentFailure(e.toString()));
    }
  }

  /// Fetch more pages
  Future<void> fetchMoreDriverAssignments() async {
    if (_isLoadingMore || !_hasNextPage) return;
    _isLoadingMore = true;
    _currentPage++;

    emit(DriverAssignmentLoadingMore(driverAssignmentModel, _hasNextPage));

    try {
      final newData = await driverAssignmentRepo.getDriverAssignments(
        _currentPage,
      );

      if (newData != null && newData.data?.results?.isNotEmpty == true) {
        // Merge existing results + new results
        final combinedResults = List<Results>.from(
          driverAssignmentModel.data?.results ?? [],
        )..addAll(newData.data!.results!);

        // Create updated Data object
        final updatedData = Data(
          page: newData.data?.page,
          nextPage: newData.data?.nextPage,
          prevPage: newData.data?.prevPage,
          count: newData.data?.count,
          rowsPerPage: newData.data?.rowsPerPage,
          results: combinedResults,
        );

        driverAssignmentModel = DriverAssignmentModel(
          success: newData.success,
          message: newData.message,
          data: updatedData,
        );

        _hasNextPage = newData.data?.nextPage != null;
        emit(DriverAssignmentLoaded(driverAssignmentModel, _hasNextPage));
      }
    } catch (e) {
      emit(DriverAssignmentFailure(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}

