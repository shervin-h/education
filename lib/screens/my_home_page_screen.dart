import 'package:education/models/user.dart';
import 'package:education/providers/theme_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:education/screens/pages/home_page_.dart';
import 'package:provider/provider.dart';
import 'pages/category_list_page.dart';
import 'pages/search_page.dart';
import 'pages/news_page.dart';
import 'pages/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:education/ui/theme.dart';

class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({Key? key}) : super(key: key);

  static const String routeName = 'MyHomePageScreen';

  @override
  _MyHomePageScreenState createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _index = 0;
  final List<Widget> _pages = const [
    Home(),
    CategoryListPage(),
    SearchPage(),
    NewsPage(),
    UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: materialGrey,
    //     // statusBarColor: backgroundColor,
    //   ),
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _changeSelectedIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final routeArgs = ModalRoute.of(context)!.settings.arguments as User?;
    // if (_pages.isEmpty){
    //   setState(() {
    //     _pages = [
    //
    //     ];
    //   });
    // }

    // final routeArgs =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //
    // _pages = [
    //   HomePage(
    //     videos: routeArgs['videoList'] as List<Video>,
    //     slides: routeArgs['slideList'] as List<Slide>,
    //     mostVisitedVideos: routeArgs['mostVisitedVideos'],
    //   ),
    //   CategoryListPage(
    //     categories: routeArgs['categoryList'] as List<Category>,
    //   ),
    //   const SearchPage(),
    //   const DownloadPage(),
    //   UserPage(
    //     user: _user,
    //   ),
    // ];
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: (Provider.of<ThemeInfo>(context).isDark) ? materialGrey : lightMaterialGrey,
        // statusBarColor: backgroundColor,
      ),
    );

    bool isDark = Provider.of<ThemeInfo>(context).isDark;

    return Scaffold(
      body: _pages.elementAt(_index),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: (_index == 0)
                    ? const Icon(CupertinoIcons.house_alt_fill)
                    : const Icon(CupertinoIcons.house_alt),
                label: 'خانه'),
            BottomNavigationBarItem(
                icon: (_index == 1)
                    ? const Icon(CupertinoIcons.square_grid_2x2_fill)
                    : const Icon(CupertinoIcons.square_grid_2x2),
                label: 'دسته بندی'),
            BottomNavigationBarItem(
                icon: (_index == 2)
                    ? const Icon(CupertinoIcons.search)
                    : const Icon(CupertinoIcons.search),
                label: 'جستجو'),
            BottomNavigationBarItem(
                icon: (_index == 3)
                    ? const Icon(CupertinoIcons.news_solid)
                    : const Icon(CupertinoIcons.news),
                label: 'اخبار تکنولوژی'),
            BottomNavigationBarItem(
                icon: (_index == 4)
                    ? const Icon(CupertinoIcons.person_fill)
                    : const Icon(CupertinoIcons.person),
                label: 'پروفایل'),
          ],
          currentIndex: _index,
          backgroundColor: isDark ? materialGrey : lightMaterialGrey,
          selectedItemColor: isDark ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
          unselectedItemColor: isDark ? Theme.of(context).iconTheme.color : Colors.grey[600],
          onTap: _changeSelectedIndex,
        ),
      ),
    );
  }
}
