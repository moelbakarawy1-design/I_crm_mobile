import 'package:admin_app/featuer/home/data/model/DashboardResponse.dart';


// States
abstract class DashboardState {}
class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardSuccess extends DashboardState {
  final DashboardData data;
  DashboardSuccess(this.data);
}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
