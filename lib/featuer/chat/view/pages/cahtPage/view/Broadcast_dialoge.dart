import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ✅ Import your Cubits
import '../../../../manager/BroadcastCubit.dart';
import '../../../../manager/broadcast_state.dart';
import '../../../../manager/chat_cubit.dart'; // Import ChatCubit

class BroadcastDialog extends StatefulWidget {
  const BroadcastDialog({super.key});

  @override
  State<BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends State<BroadcastDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BroadcastCubit, BroadcastState>(
      listener: (context, state) {
        if (state is BroadcastSuccess) {
          Navigator.pop(context);

          context.read<ChatCubit>().fetchAllChats();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Sent to ${state.totalReceivers} users!"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is BroadcastFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BroadcastLoading;

        return AlertDialog(
          title: const Text("📢 Send Broadcast"),
          content: TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Type your announcement here...",
              border: OutlineInputBorder(),
            ),
            enabled: !isLoading,
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<BroadcastCubit>().sendBroadcast(
                        _controller.text,
                      );
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Send", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
