import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
      BoxConstraints(
maxHeight: MediaQuery.of(context).size.width -45
    ),
    child: Card(color:Color(0xFFdcf8c6) ,),
     );
  }
}