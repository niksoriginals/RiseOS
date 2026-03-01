import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xrisepvtz/spotify/common/helpers/is_dark_mode.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          hideBack: true,
          action: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          title: SvgPicture.asset(
            AppVectors.logo,
            height: 40,
            width: 40,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _homeTopCard(),
            _Tab(tabController: _tabController),
            Container(
              height: 50,
              width: 50,
              color: Colors.amber,
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.blue,
            ),
            Container(
              height: 50,
              width: 50,
              color: Colors.deepOrangeAccent,
            ),
          ],
        ));
  }

  Widget _homeTopCard() {
    return Center(
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Image.asset(AppImages.homeArtist),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        indicatorColor: AppColors.primary,
        indicatorPadding: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(
            horizontal: 0.0, vertical: 10), // Consistent padding on both sides
        tabs: [
          Tab(text: 'Music'),
          Tab(text: 'News'),
          Tab(text: 'Videos'),
          Tab(text: 'Podcasts'),
        ],
      ),
    );
  }
}
