import 'dart:ui';
import 'dart:math';
import 'package:education/helpers/preferences.dart';
import 'package:education/providers/theme_info.dart';
import 'package:education/screens/about_me_screen.dart';
import 'package:education/screens/settings_screen.dart';
import 'package:education/screens/social_networks_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:education/helpers/clippers/curve_clipper.dart';
import 'package:education/models/user.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/screens/login_screen.dart';
import 'package:education/widgets/profile_page_item_widget.dart';
import 'package:education/screens/user_page/videos_list_screen.dart';
import 'package:education/helpers/helper_enums.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {

  int randomNumber = 0;
  late AnimationController _animationController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    Random random = Random();
    randomNumber = random.nextInt(8) + 8;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<Map<String, String>> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String version = packageInfo.version;
    // packageName = packageInfo.packageName;
    // buildNumber = packageInfo.buildNumber;

    return {'appName': appName, 'version': version};
  }

  Future _logout(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    await EducationPreferences.deleteUserPreferences();
    Provider.of<UserData>(context, listen: false).removeUser();

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserData>(context).user;
    bool isDark = Provider.of<ThemeInfo>(context).isDark;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        84;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Map<String, String>>(
        future: _getAppInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                color: Theme.of(context).primaryColor,
                radius: 16,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'اشکالی در گرفتن شماره نسخه اپلیکیشن پیش آمد!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Theme.of(context).errorColor),
                ),
              );
            } else if (snapshot.hasData) {
              Map<String, String> appInfo = snapshot.data!;
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                (user != null)
                                    ? 'سلام ${user.userName}'
                                    : 'هنوز وارد نشده اید!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: (user != null)
                                          ? Theme.of(context).primaryColorDark
                                          : Theme.of(context).errorColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                onTap: (user != null)
                                    ? () {
                                        _logout(context);
                                      }
                                    : () {
                                        Navigator.of(context)
                                            .pushNamed(LoginScreen.routeName);
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: (isProcessing)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (user != null)
                                                  ? 'خروج'
                                                  : 'ورود یا ثبت نام',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button!
                                                  .copyWith(
                                                      color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            CupertinoActivityIndicator(
                                              radius:
                                                  (screenHeight * 0.06) * 0.4,
                                              color: Colors.white,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          (user != null)
                                              ? 'خروج'
                                              : 'ورود یا ثبت نام',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button!
                                              .copyWith(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.time,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'ویدیو های مشاهده شده',
                            onTap: () {
                              Navigator.of(context).pushNamed(Videos.routeName,
                                  arguments: ListType.considered);
                            },
                          ),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.bookmark,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'لیست علاقه مندی ها',
                            onTap: () {
                              Navigator.of(context).pushNamed(Videos.routeName,
                                  arguments: ListType.bookmarked);
                            },
                          ),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.arrow_down_to_line,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'لیست دانلود ها',
                            onTap: () {},
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.hand_thumbsup,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'شبکه های اجتماعی',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SocialNetworks.routeName);
                            },
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: FontAwesomeIcons.ello,
                            iconColor: Theme.of(context).primaryColorDark,
                            title: 'درباره من',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AboutMe.routeName);
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: Text(
                              // s[0].toUpperCase() + s.substring(1)
                              // -> Capitalize the first character of a string
                              (appInfo['appName'] != null)
                                  ? '${appInfo['appName']![0].toUpperCase()}${appInfo['appName']!.substring(1)}'
                                  : 'Education',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorDark),
                            ),
                            title: Text('نسخه  ${appInfo['version'] ?? ''}'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipPath(
                        clipper: CurveClipper(),
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/background_$randomNumber.jpg'),
                              fit: BoxFit.cover,
                              onError: (error, stackTrace) {},
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              // print(_animationController.value * 2 * pi);
                              return Transform.rotate(
                                angle: _animationController.value * 2 * pi,
                                child: child,
                              );
                            },
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Settings.routeName);
                              },
                              icon: const Icon(
                                CupertinoIcons.settings,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 8,
                              sigmaY: 8,
                            ),
                            child: (user != null)
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade900
                                              .withOpacity(0.8),
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                    child: Image(
                                      width: screenWidth * 0.24,
                                      height: screenWidth * 0.24,
                                      image: const AssetImage(
                                        'assets/images/placeholder_user.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: screenWidth * 0.24,
                                    height: screenWidth * 0.24,
                                    alignment: Alignment.center,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.transparent,
                                      highlightColor:
                                          Theme.of(context).primaryColor,
                                      period: const Duration(
                                        seconds: 3,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person,
                                        size: screenWidth * 0.20,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                (user != null)
                                    ? 'سلام ${user.userName}'
                                    : 'هنوز وارد نشده اید!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: (user != null)
                                          ? Theme.of(context).primaryColorDark
                                          : Theme.of(context).errorColor,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                onTap: (user != null)
                                    ? () {
                                        _logout(context);
                                      }
                                    : () {
                                        Navigator.of(context)
                                            .pushNamed(LoginScreen.routeName);
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: (isProcessing)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (user != null)
                                                  ? 'خروج'
                                                  : 'ورود یا ثبت نام',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                              textAlign: TextAlign.center,
                                            ),
                                            CupertinoActivityIndicator(
                                              radius:
                                                  (screenHeight * 0.06) * 0.4,
                                              color: Colors.white,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          (user != null)
                                              ? 'خروج'
                                              : 'ورود یا ثبت نام',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.time,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'ویدیو های مشاهده شده',
                            onTap: () {
                              Navigator.of(context).pushNamed(Videos.routeName,
                                  arguments: ListType.considered);
                            },
                          ),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.bookmark,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'لیست علاقه مندی ها',
                            onTap: () {
                              Navigator.of(context).pushNamed(Videos.routeName,
                                  arguments: ListType.bookmarked);
                            },
                          ),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.arrow_down_to_line,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'لیست دانلود ها',
                            onTap: () {},
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: CupertinoIcons.hand_thumbsup,
                            iconColor: Theme.of(context).iconTheme.color,
                            title: 'شبکه های اجتماعی',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SocialNetworks.routeName);
                            },
                          ),
                          const Divider(),
                          ProfilePageItemWidget(
                            iconData: FontAwesomeIcons.ello,
                            iconColor: Theme.of(context).primaryColorDark,
                            title: 'درباره من',
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AboutMe.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipPath(
                        clipper: CurveClipper(),
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/images/background_9.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              // print(_animationController.value * 2 * pi);
                              return Transform.rotate(
                                angle: _animationController.value * 2 * pi,
                                child: child,
                              );
                            },
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Settings.routeName);
                              },
                              icon: const Icon(
                                CupertinoIcons.settings,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 8,
                              sigmaY: 8,
                            ),
                            child: (user != null)
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade900
                                              .withOpacity(0.8),
                                          blurRadius: 8,
                                        )
                                      ],
                                    ),
                                    child: Image(
                                      width: screenWidth * 0.24,
                                      height: screenWidth * 0.24,
                                      image: const AssetImage(
                                        'assets/images/placeholder_user.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: screenWidth * 0.24,
                                    height: screenWidth * 0.24,
                                    alignment: Alignment.center,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.transparent,
                                      highlightColor:
                                          Theme.of(context).primaryColor,
                                      period: const Duration(
                                        seconds: 3,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.person,
                                        size: screenWidth * 0.20,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else {
            return Text(
              '${snapshot.connectionState}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Theme.of(context).errorColor),
            );
          }
        },
      ),
    );
  }
}
