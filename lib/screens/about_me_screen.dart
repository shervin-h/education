import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:education/ui/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);

  static const String routeName = 'AboutMeScreen';

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  int randomNumber = 0;
  bool qrMode = false;
  List<Map<String, String>> myAppsInfo = [
    {
      'name_fa': 'آب و هوا',
      'name_en': 'Climate',
      'qr': 'https://s6.uupload.ir/files/آب_و_هوا_qv8h.png',
      'image': 'https://s6.uupload.ir/files/shervin.hasanzadeh.climate-82ae0f6e-8c2a-420d-9df3-38ac06114770_128x128_8az7.png',
      'link': 'https://cafebazaar.ir/app/shervin.hasanzadeh.climate',
    },
    {
      'name_fa': 'لیست کارها',
      'name_en': 'Todo',
      'qr': 'https://s6.uupload.ir/files/لیست_کار_ها_jf4e.png',
      'image':
      'https://s6.uupload.ir/files/shervin.hasanzadeh.todo-7046fec0-2e4f-48af-9507-aa4f861eadb0_128x128_0zdt.png',
      'link': 'https://cafebazaar.ir/app/shervin.hasanzadeh.todo'

    },
    {
      'name_fa': 'نرخ رمزارزها - ارز های دیجیتال',
      'name_en': 'Digital Currencies Rate',
      'qr': 'https://s6.uupload.ir/files/نرخ_رمز_ارز_ها_l9d1.png',
      'image':
      'https://s6.uupload.ir/files/shervin.hasanzadeh.digital_currency-8745a06e-d3f4-44ab-b05d-31f38c1b1029_128x128_3ku.png',
      'link': 'https://cafebazaar.ir/app/shervin.hasanzadeh.digital_currency'
    },
    {
      'name_fa': 'دوز',
      'name_en': 'TicTacToe',
      'qr': 'https://s6.uupload.ir/files/دوز_0t1c.png',
      'image':
      'https://s6.uupload.ir/files/shervin.hasanzadeh.connect3-af8d8fb1-723e-40bc-bb76-23f32bc8176a_128x128_9cp7.png',
      'link': 'https://cafebazaar.ir/app/shervin.hasanzadeh.connect3'
    },
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    Random random = Random();
    randomNumber = random.nextInt(15) + 1;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            // margin: EdgeInsets.only(top: screenHeight * 0.4),
            padding: EdgeInsets.fromLTRB(
                0, (screenHeight * 0.4) /*+ (screenHeight * 0.03) + 16*/, 0, 0),
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03 + 16),
                  ListTile(
                    title: Text(
                      'درباره من',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        shadows: [],
                      ),
                    ),
                    subtitle: Text(
                      'سلام خدمت شما کاربر گرامی :) \nمن از دوران دبیرستان به حوزه فناوری آی تی و کامپیوتر علاقه داشتم. منتهی روزگار سرنوشت دیگری برای من رقم زد. من شیمی کاربردی خوندم. و در دنیایی کاملا متفاوت به سر میبردم. \nتا اینکه چهار سال پیش از محیط امن خودم بیرون اومدم و فصل جدیدی در زندگی من شروع شد.\nهر روز چیز های جدید یاد میگیرم و در هیچ سطحی متوقف نمیشوم.\nچهار سال پیش با برنامه‌نویسی جاوا و اندروید شروع کردم، به حوزه برنامه نویسی وب علاقه مند شدم.\nپایتون رو یاد گرفتم وبعد به سراغ جنگو رفتم. یک سالی بود زیاد در مورد فریمورک فلاتر میشنیدم. پس امتحانش کردم و به معنای حقیقی کلمه شگفت زده شدم...\nراستش رو بگم انگیزه و علاقه‌ی بیشتری به نوشتن اپلیکیشن های موبایل دارم تا برنامه نویسی وب. دوست دارم چیز جدید و منحصر به فردی رو خلق کنم ... ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        shadows: [],
                        height: 1.4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 8, 32, 0),
                    child: Divider(color: lightMaterialGrey,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('نمایش کیو آٰر:', style: Theme.of(context).textTheme.caption!.copyWith(color: materialGrey),),
                        Switch(
                          activeColor: Theme.of(context).primaryColorDark,
                          inactiveTrackColor: Colors.grey[300],
                          value: qrMode,
                          onChanged: (bool value) {
                            setState(() {
                              qrMode = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                    width: screenWidth,
                    height: screenHeight * 0.24,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: myAppsInfo.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (Platform.isAndroid) {
                              AndroidIntent intent = AndroidIntent(
                                action: 'action_view',
                                data: myAppsInfo[index]['link'],
                              );
                              await intent.launch();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            width: screenWidth * 0.3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                FadeInImage(
                                  image: NetworkImage((qrMode) ? myAppsInfo[index]['qr']! : myAppsInfo[index]['image']!),
                                  placeholder: const AssetImage('assets/images/placeholder_video.png'),
                                  placeholderFit: BoxFit.scaleDown,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/images/placeholder_video.png', fit: BoxFit.scaleDown,);
                                  },
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  myAppsInfo[index]['name_en']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.caption!
                                      .copyWith(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      shadows: []),
                                ),
                                const SizedBox(height: 8,),
                                Text(
                                  myAppsInfo[index]['name_fa']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.caption!
                                      .copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      shadows: []),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      AssetImage('assets/images/background_$randomNumber.jpg'),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {}),
              color: Colors.lightBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.transparent,
                          highlightColor: Theme.of(context).primaryColor,
                          period: const Duration(seconds: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: CircularText(
                              children: [
                                TextItem(
                                  text: Text(
                                    'SHERVIN HASANZADEH',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  space: 12,
                                  startAngle: -90,
                                  startAngleAlignment:
                                      StartAngleAlignment.center,
                                  direction: CircularTextDirection.clockwise,
                                ),
                              ],
                              radius: 46,
                              position: CircularTextPosition.outside,
                              backgroundPaint: Paint()
                                ..color = Colors.transparent,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/images/my_pic.png'),
                          backgroundColor: Colors.white.withOpacity(0.6),
                          radius: 46,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        'شروین حسن زاده',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'برنامه نویس فلاتر و اندروید',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'علاقه‌مند به پایتون، جنگو و لینوکس',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Positioned(
                  bottom: -(screenHeight * 0.03),
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    height: screenHeight * 0.06,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  AndroidIntent intent = const AndroidIntent(
                                    action: 'action_view',
                                    data:
                                        'https://www.instagram.com/shervin_hz70/',
                                  );
                                  await intent.launch();
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  AndroidIntent intent = const AndroidIntent(
                                    action: 'action_view',
                                    data:
                                        'https://www.linkedin.com/in/shervin-hasanzadeh',
                                  );
                                  await intent.launch();
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.linkedin,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  AndroidIntent intent = const AndroidIntent(
                                    action: 'android.intent.action.SEND',
                                    arguments: {
                                      'android.intent.extra.SUBJECT':
                                          'Hi Shervin, '
                                    },
                                    arrayArguments: {
                                      'android.intent.extra.EMAIL': [
                                        'shervin.hz07@gmail.com'
                                      ],
                                      // 'android.intent.extra.CC': ['john@app.com', 'user@app.com'],
                                      // 'android.intent.extra.BCC': ['liam@me.abc', 'abel@me.com'],
                                    },
                                    package: 'com.google.android.gm',
                                    type: 'message/rfc822',
                                  );
                                  await intent.launch();
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.mail,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  AndroidIntent intent = const AndroidIntent(
                                    action: 'action_view',
                                    data: 'https://myWhatsappLink',
                                  );
                                  await intent.launch();
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (Platform.isAndroid) {
                                  AndroidIntent intent = const AndroidIntent(
                                    action: 'action_view',
                                    data: 'https://t.me/shervin_hz07',
                                  );
                                  await intent.launch();
                                }
                              },
                              icon: const Icon(
                                FontAwesomeIcons.telegramPlane,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(CupertinoIcons.right_chevron),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class UsableCard extends StatelessWidget {
  const UsableCard(
      {required this.widget,
      this.radius = 8,
      this.height,
      this.width,
      Key? key})
      : super(key: key);

  final Widget widget;
  final double radius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: widget,
        ),
      ),
    );
  }
}
