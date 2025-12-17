import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/data/repo/chat_repo.dart';
import 'package:admin_app/featuer/chat/manager/BroadcastCubit.dart';
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

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Tab Controller
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ChatCubit(
              ChatRepository(),
              MessagesRepository(),
              SocketService(),
            )..fetchAllChats();
          },
        ),
        BlocProvider(
          create: (context) {
            return BroadcastCubit(MessagesRepository(), SocketService());
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Scaffold(
              appBar: AnimatedChatAppBar(
                tabController: _tabController,
                onBackPressed: () {
                  Navigator.pop(context);
                },
                onSearchChanged: (query) {
                  try {
                    final cubit = context.read<ChatCubit>();
                    cubit.searchChats(query);
                  } catch (e) {
                    print("❌  accessing ChatCubit: $e");
                  }
                },
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [CahtPage(), CallsPage()],
              ),
            ),
          );
        },
      ),
    );
  }
}
