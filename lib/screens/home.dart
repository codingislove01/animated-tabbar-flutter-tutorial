import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Home',
      icon: Icon(CupertinoIcons.home),
    ),
    Tab(
      text: 'Favorites',
      icon: Icon(CupertinoIcons.heart),
    ),
    Tab(
      text: 'Settings',
      icon: Icon(CupertinoIcons.gear),
    ),
    Tab(
      text: 'Profile',
      icon: Icon(CupertinoIcons.person),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedTabBar(
        tabs: myTabs,
        controller: _tabController,
      ),
      body: Container(
        color: const Color(0xFFF6FE63),
        child: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            return Center(
              child: tab.icon,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AnimatedTabBar extends StatefulWidget {
  const AnimatedTabBar(
      {super.key, required this.tabs, required this.controller});
  final List<Tab> tabs;
  final TabController controller;

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBar();
}

class _AnimatedTabBar extends State<AnimatedTabBar> {
  final animationDuration = const Duration(milliseconds: 300);
  final animationCurve = Curves.easeInOut;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      tabIndex = widget.controller.index;
    });
    widget.controller.addListener(() {
      if (widget.controller.indexIsChanging) {
        setState(() {
          tabIndex = widget.controller.index;
        });
      }
    });
  }

  final tabHeight = 60.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: tabHeight,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: animationDuration,
            curve: animationCurve,
            alignment:
                FractionalOffset(1 / (widget.tabs.length - 1) * tabIndex, 0),
            child: Container(
              height: tabHeight,
              color: Colors.transparent,
              child: FractionallySizedBox(
                widthFactor: 1 / widget.tabs.length,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      '${widget.tabs[tabIndex].text}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
              children: widget.tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final tab = entry.value;
            final isActiveTab = i == tabIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => widget.controller.animateTo(i),
                child: Container(
                    color: Colors.transparent,
                    height: tabHeight,
                    child: AnimatedOpacity(
                      duration: animationDuration,
                      opacity: isActiveTab ? 1 : 0.25,
                      child: AnimatedSlide(
                          duration: animationDuration,
                          offset: Offset(0, isActiveTab ? -0.15 : 0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: animationDuration,
                                opacity: isActiveTab ? 1 : 0,
                                child: Transform.translate(
                                  offset: const Offset(8, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      color: Colors.yellow.withOpacity(0.5),
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ),
                              tab.icon ?? const Icon(CupertinoIcons.home),
                            ],
                          )),
                    )),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }
}
