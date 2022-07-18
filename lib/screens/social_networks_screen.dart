import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
// import 'package:platform/platform.dart';

class SocialNetworks extends StatelessWidget {
  const SocialNetworks({Key? key}) : super(key: key);

  static const String routeName = 'SocialNetworks';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SocialNetworkItem(
              iconData: CupertinoIcons.mail,
              title: 'ایمیل',
              onTap: () async {
                if (Platform.isAndroid) {
                  AndroidIntent intent = const AndroidIntent(
                    action: 'android.intent.action.SEND',
                    arguments: {'android.intent.extra.SUBJECT': 'Hi Shervin, '},
                    arrayArguments: {
                      'android.intent.extra.EMAIL': ['shervin.hz07@gmail.com'],
                      // 'android.intent.extra.CC': ['john@app.com', 'user@app.com'],
                      // 'android.intent.extra.BCC': ['liam@me.abc', 'abel@me.com'],
                    },
                    package: 'com.google.android.gm',
                    type: 'message/rfc822',
                  );
                  await intent.launch();
                }
              },
            ),
            SocialNetworkItem(
              iconData: FontAwesomeIcons.instagram,
              title: 'اینستاگرام',
              onTap: () async {
                if (Platform.isAndroid) {
                  AndroidIntent intent = const AndroidIntent(
                    action: 'action_view',
                    data: 'https://www.instagram.com/shervin_hz70/',
                  );
                  await intent.launch();
                }
              },
            ),
            SocialNetworkItem(
              iconData: FontAwesomeIcons.linkedin,
              title: 'لینکداین',
              onTap: () async {
                if (Platform.isAndroid) {
                  AndroidIntent intent = const AndroidIntent(
                    action: 'action_view',
                    data: 'https://www.linkedin.com/in/shervin-hasanzadeh',
                  );
                  await intent.launch();
                }
              },
            ),
            SocialNetworkItem(
              iconData: FontAwesomeIcons.telegramPlane,
              title: 'تلگرام',
              onTap: () async {
                if (Platform.isAndroid) {
                  AndroidIntent intent = const AndroidIntent(
                    action: 'action_view',
                    data: 'https://t.me/androidprogramming_ir',
                  );
                  await intent.launch();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /*
  //////////////////////
  ////// Examples //////
  //////////////////////

  void _openGoogleMapsStreetView() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('google.streetview:cbll=46.414382,10.013988'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _displayMapInGoogleMaps({int zoomLevel = 12}) {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('geo:37.7749,-122.4194?z=$zoomLevel'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _launchTurnByTurnNavigationInGoogleMaps() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull(
            'google.navigation:q=Taronga+Zoo,+Sydney+Australia&avoid=tf'),
        package: 'com.google.android.apps.maps');
    intent.launch();
  }

  void _openLinkInGoogleChrome() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://flutter.dev'),
        package: 'com.android.chrome');
    intent.launch();
  }

  void _startActivityInNewTask() {
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('https://flutter.dev'),
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  void _testExplicitIntentFallback() {
    final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('https://flutter.dev'),
        package: 'com.android.chrome.implicit.fallback');
    intent.launch();
  }

  void _openLocationSettingsConfiguration() {
    const AndroidIntent intent = AndroidIntent(
      action: 'action_location_source_settings',
    );
    intent.launch();
  }

  void _openApplicationDetails() {
    const intent = AndroidIntent(
      action: 'action_application_details_settings',
      data: 'package:io.flutter.plugins.androidintentexample',
    );
    intent.launch();
  }

  void _openGmail() {
    const intent = AndroidIntent(
      action: 'android.intent.action.SEND',
      arguments: {'android.intent.extra.SUBJECT': 'I am the subject'},
      arrayArguments: {
        'android.intent.extra.EMAIL': ['eidac@me.com', 'overbom@mac.com'],
        'android.intent.extra.CC': ['john@app.com', 'user@app.com'],
        'android.intent.extra.BCC': ['liam@me.abc', 'abel@me.com'],
      },
      package: 'com.google.android.gm',
      type: 'message/rfc822',
    );
    intent.launch();
  }
  */
}

class SocialNetworkItem extends StatelessWidget {
  const SocialNetworkItem({
    required this.iconData,
    required this.title,
    required this.onTap,
    Key? key
  }) : super(key: key);

  final IconData iconData;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          iconData
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

