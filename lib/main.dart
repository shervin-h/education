import 'dart:io';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:education/screens/splash_screen.dart';
import 'package:education/screens/videos_list_screen.dart' as all;
import 'package:education/screens/categorized_videos_list_screen.dart';
import 'package:education/screens/login_screen.dart';
import 'package:education/screens/register_screen.dart';
import 'package:education/screens/user_page/videos_list_screen.dart' as user;
import 'package:education/screens/social_networks_screen.dart';
import 'package:education/screens/about_me_screen.dart';
import 'package:education/providers/videos_data.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/providers/theme_info.dart';
import 'package:education/screens/settings_screen.dart';

import 'screens/my_home_page_screen.dart';
import 'ui/theme.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

    runApp(
      /// Providers are above [MyApp] instead of inside it, so that tests
      /// can use [MyApp] while mocking the providers
      MultiProvider(
        providers: [
          ChangeNotifierProvider<VideosData>(
              create: (context) => VideosData()
          ),
          ChangeNotifierProvider<UserData>(
              create: (context) => UserData(),
          ),
          ChangeNotifierProvider<ThemeInfo>(
            create: (context) => ThemeInfo(),
          ),
        ],
        child: const MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fa', ''),
      ],
      locale: const Locale('fa'),

      theme: setPreferredThemeData(
        Provider.of<ThemeInfo>(context).isDark,
        Provider.of<ThemeInfo>(context).fontFamily,
      ),

      home: const SplashScreen(),
      routes: {
        MyHomePageScreen.routeName: (context) => const MyHomePageScreen(),
        all.Videos.routeName : (context) => const all.Videos(),
        CategorizedVideos.routeName : (context) => const CategorizedVideos(),
        user.Videos.routeName: (context) => const user.Videos(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SocialNetworks.routeName: (context) => const SocialNetworks(),
        AboutMe.routeName: (context) => const AboutMe(),
        Settings.routeName: (context) => const Settings(),

      },
    );
  }
}
