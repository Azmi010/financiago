import 'package:flutter/material.dart';
import 'package:safeloan/app/utils/warna.dart';

class TabBarWidget extends StatelessWidget {
  final List<Widget> views;
  final List<String> tabLabels;

  const TabBarWidget({
    super.key,
    required this.views,
    required this.tabLabels,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabels.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(2),
              height: 50,
              decoration: BoxDecoration(
                color: Utils.backgroundCard,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 30,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: Utils.biruTiga,  
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: tabLabels.map((label) => Tab(text: label)).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: views,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
