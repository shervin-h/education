import 'package:education/providers/theme_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education/helpers/preferences.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  static const String routeName = 'SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeInfo>(
        builder: (context, themeInfo, child) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(
                  themeInfo.isDark
                      ? CupertinoIcons.moon_stars
                      : CupertinoIcons.brightness,
                ),
                title: Text(
                  themeInfo.isDark ? 'تم تیره' : 'تم روشن',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: themeInfo.isDark,
                  onChanged: (bool value) {
                    themeInfo.changeBrightness();
                    EducationPreferences.setSettingsPreferences(isDark: themeInfo.isDark);
                  },
                ),
              ),

              ListTile(
                leading: Icon(
                  themeInfo.fontFamily == 'BYekan'
                      ? CupertinoIcons.textformat
                      : CupertinoIcons.textformat_abc,
                ),
                title: Text(
                  themeInfo.fontFamily,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                subtitle: Text(
                  ' می‌توانید از فونت بی‌یکان یا وزیر برای راحتی در مطالعه متن‌ها استفاده کنید',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.grey[500]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: CupertinoSlidingSegmentedControl(
                  thumbColor: Theme.of(context).primaryColor,
                  groupValue: themeInfo.fontFamily,
                  children: {
                    'BYekan': Text(
                      'BYekan',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        shadows: [
                          Shadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                    'Vazir': Text(
                      'Vazir',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        shadows: [
                          Shadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  },
                  onValueChanged: (fontFamily) {
                    themeInfo.setFontFamily(fontFamily as String);
                    EducationPreferences.setSettingsPreferences(fontFamily: fontFamily);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
