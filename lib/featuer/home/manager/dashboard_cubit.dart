import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';
import 'package:admin_app/featuer/home/data/repo/DashboardRepo.dart';
import 'package:admin_app/featuer/home/manager/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repo;

  DashboardCubit(this._repo) : super(DashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(DashboardLoading());
    try {
      final data = await _repo.getDashboardStats();
      emit(DashboardSuccess(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  
  List<ChartData> getChatsPerDay(List<LatestChat>? chats) {
    if (chats == null || chats.isEmpty) return [];

    Map<String, int> grouped = {};

    for (var chat in chats) {
      if (chat.createdAt != null) {
        try {
          final DateTime date = DateTime.parse(chat.createdAt!);
          String formattedDate = DateFormat('MMM d').format(date);
          grouped[formattedDate] = (grouped[formattedDate] ?? 0) + 1;
        } catch (e) {
          print("Error parsing date: $e");
        }
      }
    }

    return grouped.entries
        .map((e) => ChartData(e.key, e.value.toDouble()))
        .toList();
  }
}

/// Simple model for Chart Data
class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);
}