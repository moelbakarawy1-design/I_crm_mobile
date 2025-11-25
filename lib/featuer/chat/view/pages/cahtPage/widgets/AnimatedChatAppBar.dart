import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class AnimatedChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;
  final VoidCallback onBackPressed;
  final Function(String)? onSearchChanged;

  const AnimatedChatAppBar({
    super.key,
    required this.tabController,
    required this.onBackPressed,
    this.onSearchChanged, 
  });

  @override
  State<AnimatedChatAppBar> createState() => _AnimatedChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}

class _AnimatedChatAppBarState extends State<AnimatedChatAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // 🔍 Search state
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();       
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
    
    //  Add listener to search controller
    _searchController.addListener(() {
      final text = _searchController.text;
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(text);
      } else {
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      backgroundColor: AppColor.lightBlue,

      // ▶ Leading Button
      leading: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value.clamp(0.0, 1.0),
            child: IconButton(
              color: AppColor.mainWhite,
              onPressed: () {
                if (isSearching) {
                  setState(() {
                    isSearching = false;
                    _searchController.clear();
                  });
                } else {
                  widget.onBackPressed();
                }
              },
              icon: Icon(isSearching ? Icons.close : Icons.arrow_back_ios),
            ),
          );
        },
      ),

      // Title (Search or Normal Title)
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSearching ? _buildSearchField() : _buildDefaultTitle(),
      ),

      //  Actions
      actions: [
        _buildAnimatedAction(
          icon: isSearching ? Icons.close : Icons.search,
          delay: 0.1,
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
        _buildAnimatedAction(
          icon: Icons.more_vert,
          delay: 0.2,
          isMenu: true,
        ),
      ],

      // ▶ TabBar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - _controller.value)),
              child: Opacity(
                opacity: _controller.value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: isSearching
              ? const SizedBox.shrink()
              : TabBar(
                  controller: widget.tabController,
                  unselectedLabelColor: AppColor.mainWhite.withOpacity(0.7),
                  labelColor: AppColor.mainWhite,
                  indicatorColor: AppColor.mainWhite,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(text: "Chats"),
                    Tab(text: "Calls"),
                  ],
                ),
        ),
      ),
    );
  }

  // 🔍 Rounded Material You Search Field
  Widget _buildSearchField() {
    return Container(
      key: const ValueKey("search"),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) {
              },
            ),
          ),
        ],
      ),
    );
  }

  // ▶ Normal AppBar Title
  Widget _buildDefaultTitle() {
    return Row(
      key: const ValueKey("title"),
      children: [
        Icon(Icons.chat_bubble, color: AppColor.mainWhite, size: 24),
        const SizedBox(width: 8),
        Text(
          'WhatsApp',
          style: AppTextStyle.setpoppinsWhite(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ▶ Animated Actions (Search, Menu)
  Widget _buildAnimatedAction({
    required IconData icon,
    required double delay,
    VoidCallback? onPressed,
    bool isMenu = false,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeOut.transform(
          ((_controller.value - delay).clamp(0.0, 1.0)),
        );

        return Transform.scale(
          scale: progress.clamp(0.0, 1.0),
          child: Opacity(
            opacity: progress.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: isMenu
          ? PopupMenuButton<String>(
              iconColor: AppColor.mainWhite,
              icon: Icon(icon),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  _buildMenuItem('New group', Icons.group_add),
                  _buildMenuItem('New broadcast', Icons.campaign),
                  _buildMenuItem('Settings', Icons.settings),
                  _buildMenuItem('WhatsApp Web', Icons.web),
                ];
              },
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value selected')),
                );
              },
            )
          : IconButton(
              onPressed: onPressed,
              icon: Icon(icon),
              color: AppColor.mainWhite,
            ),
    );
  }

  // ▶ Popup Menu Item
  PopupMenuItem<String> _buildMenuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}