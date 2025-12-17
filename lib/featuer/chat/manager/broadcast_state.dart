abstract class BroadcastState {}

class BroadcastInitial extends BroadcastState {}

class BroadcastLoading extends BroadcastState {}

class BroadcastSuccess extends BroadcastState {
  final int totalReceivers;
  BroadcastSuccess(this.totalReceivers);
}

class BroadcastFailure extends BroadcastState {
  final String error;
  BroadcastFailure(this.error);
}
