import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:admin_app/featuer/chat/view/pages/caht_page.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
 

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(  color: AppColor.mainWhite, onPressed: () { Navigator.pop(context); }, icon:Icon( Icons.arrow_back_ios,),),
        backgroundColor: AppColor.lightBlue,
        title: Text('Whatsapp', style: AppTextStyle.setpoppinsWhite(fontSize: 14, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search), color: AppColor.mainWhite),
          PopupMenuButton<String>(
            iconColor: AppColor.mainWhite,
            itemBuilder: (BuildContext context)
          {
          return [
            PopupMenuItem(value: 'New group',child: Text('New group'), ),
            PopupMenuItem(value: 'New broadCast',child: Text('New broadCast'), ),
            PopupMenuItem(value: 'setting',child: Text('setting'), ),
            PopupMenuItem(value: 'New Watsapp Web',child: Text('New Watsapp Web'), ),
          ];
          })
        ],
        bottom: TabBar(
          unselectedLabelColor: AppColor.mainWhite,
          indicatorColor: AppColor.mainWhite,
          labelColor: AppColor.mainWhite,
          controller: _controller,
          tabs: const [
            Tab(text: "Chats"),
            Tab(text: "Call"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: 
       [
     CahtPage(),
     Text('Call'),
       ]
      ),
    );
  }
}
