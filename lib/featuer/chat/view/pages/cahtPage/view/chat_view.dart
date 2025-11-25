import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/data/repo/chat_repo.dart';
import 'package:admin_app/featuer/chat/manager/chat_cubit.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/view/caht_page.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/view/call_page_view.dart';
import 'package:admin_app/featuer/chat/view/pages/cahtPage/widgets/AnimatedChatAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    print("✅ ChatScreen initState called");
    
    // Tab Controller
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );

    // Fade Animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("✅ ChatScreen build called");
    
    return BlocProvider(
      create: (context) {
        print("✅ Creating ChatCubit");
        return ChatCubit(
          ChatRepository(),
          MessagesRepository(),
          SocketService(),
        )..fetchAllChats();
      },
      child: Builder(
        builder: (context) {
          print("✅ Builder inside BlocProvider");
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Scaffold(
              appBar: AnimatedChatAppBar(
                tabController: _tabController,
                onBackPressed: () {
                  print("🔙 Back pressed");
                  Navigator.pop(context);
                },
                onSearchChanged: (query) {
                  print("🔍🔍🔍 ChatScreen: onSearchChanged called with: '$query'");
                  try {
                    final cubit = context.read<ChatCubit>();
                    print("✅ Got cubit: $cubit");
                    cubit.searchChats(query);
                  } catch (e) {
                    print("❌❌❌ Error accessing cubit: $e");
                  }
                },
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [
                  CahtPage(),
                  CallsPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}