import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'broadcast_state.dart';

class BroadcastCubit extends Cubit<BroadcastState> {
  final MessagesRepository messagesRepository;
  final SocketService socketService;

  BroadcastCubit(this.messagesRepository, this.socketService)
    : super(BroadcastInitial());

  Future<void> sendBroadcast(String message) async {
    if (message.trim().isEmpty) {
      emit(BroadcastFailure("Message cannot be empty"));
      return;
    }

    emit(BroadcastLoading());

    try {
      final data = await messagesRepository.sendBroadcastMessage(message);

      final total = data['total'] is int ? data['total'] : 0;
      if (socketService.socket != null && !socketService.socket!.connected) {
        await socketService.connect();
      }

      emit(BroadcastSuccess(total));
    } catch (e) {
      emit(BroadcastFailure(e.toString()));
    }
  }
}
