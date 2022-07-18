import 'package:education/providers/theme_info.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/screens/pages/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:education/helpers/clippers/sine_curve_clipper.dart';
import 'package:education/helpers/preferences.dart';
import 'package:education/services/education_api.dart';
import 'package:education/widgets/user_text_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:education/models/user.dart';
import 'package:education/widgets/bottomsheet_alert_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String routeName = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _email, _username, _password, _repassword; // _firstName, _lastName, _phoneNumber, _avatar, _about, _website;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerUser(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    String? key = await EducationApi.postRegisterUser({
      "username": _username!,
      "password1": _password!,
      "password2": _password!,
      "email": _email!
    });

    if (key != null) {
      await EducationPreferences.setUserPreferences(
        _username!,
        _password!,
        _email!,
        key: key,
        // accessToken: _user.accessToken,
        // refreshToken: _user.refreshToken,
      );

      Provider.of<UserData>(context, listen: false).setUser(User(_username!, _password!, _email!, key: key));

      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
    } else {
      // 400 Bad Request
      // A user with this username already exists.
      // A user is already registered with this e-mail address.
      // This password is too short. It must contain at least 8 characters.
      // The two password fields didn't match.
      // This field may not be blank.
      // This field is required.

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(
              message: 'این نام کاربری یا این ایمیل از قبل موجود است!',
          );
        },
      );
    }

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserData>(context).user;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        84;

    return Scaffold(
      body: Consumer<ThemeInfo>(
        builder: (BuildContext context, ThemeInfo themeInfo, Widget? child) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.4),
                        Text(
                          'Education',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            letterSpacing: 4,
                            color: themeInfo.isDark
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorDark,
                          ),
                        ),
                        Text(
                          'Registration',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            color: themeInfo.isDark
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorDark,
                            letterSpacing: 2,
                          ),
                        ),
                        const Divider(),
                        SizedBox(height: screenHeight * 0.05),
                        UserTextFieldWidget(
                          onSaved: (value) => _email = value,
                          validator: (value) => (value!.trim().length < 10 ||
                              !value.trim().contains('@'))
                              ? 'ایمیل باستی شامل کاراکتر @ و حداقل ۱۰ کاراکتر باشد !'
                              : null,
                          hintText: (user == null) ? 'ایمیل' : _email!,
                          iconData: CupertinoIcons.at,
                          keyboardType: TextInputType.emailAddress,
                          // maxLength: 100,
                        ),
                        UserTextFieldWidget(
                          onSaved: (value) => _password = value,
                          validator: (value) => (value!.trim().length < 8)
                              ? 'فیلد رمز بایستی حداقل ۸ کاراکتر داشته باشد !'
                              : null,
                          hintText: (user == null) ? 'رمز' : _password!,
                          iconData: CupertinoIcons.lock,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          isSecure: true,
                          maxLines: 1,
                          // maxLength: 50,
                        ),
                        UserTextFieldWidget(
                          onSaved: (value) => _repassword = value,
                          validator: (value) => (value!.trim().length < 8)
                              ? 'فیلد تکرار رمز بایستی حداقل ۸ کاراکتر داشته باشد !'
                              : null,
                          hintText: (user == null) ? 'تکرار رمز' : _password!,
                          iconData: CupertinoIcons.lock,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          isSecure: true,
                          maxLines: 1,
                          // maxLength: 50,
                        ),
                        UserTextFieldWidget(
                          onSaved: (value) => _username = value,
                          validator: (value) => (value!.trim().length < 5)
                              ? 'نام کاربری بایستی حداقل ۵ کاراکتر باشد !'
                              : null,
                          hintText: (user == null) ? 'نام کاربری' : _username!,
                          iconData: CupertinoIcons.person_alt,
                          // maxLength: 50,
                        ),
                        /*
                    UserTextFieldWidget(
                      // onSaved: (value) => _firstName = value,
                      // validator: (value) => (value!.trim().length < 3)
                      //     ? 'نام بایستی حداقل ۳ کاراکتر داشته باشد !'
                      //     : null,
                      hintText: (user == null) ? 'نام (اختیاری)' : _firstName!,
                      iconData: CupertinoIcons.person,
                      // maxLength: 50,
                    ),
                    UserTextFieldWidget(
                      // onSaved: (value) => _lastName = value,
                      // validator: (value) => (value!.trim().length < 3)
                      //     ? 'نام خانوادگی بایستی حداقل ۳ کاراکتر داشته باشد !'
                      //     : null,
                      hintText: (user == null) ? 'نام خانوادگی (اختیاری)' : _lastName!,
                      iconData: CupertinoIcons.person_2,
                      // maxLength: 50,
                    ),
                    UserTextFieldWidget(
                      // onSaved: (value) => _phoneNumber = value,
                      // validator: (value) => (value!.trim().length != 11)
                      //     ? 'شماره تلفن بایستی ۱۱ کاراکتر باشد !'
                      //     : null,
                      hintText: (user == null) ? 'شماره تلفن (اختیاری)' : _phoneNumber!,
                      iconData: CupertinoIcons.phone_down,
                      keyboardType: TextInputType.phone,
                      // maxLength: 11,
                    ),
                    UserTextFieldWidget(
                      // onSaved: (value) => _about = value,
                      // validator: (value) => (value!.trim().isEmpty)
                      //     ? 'مقداری در مورد خودتان بنویسید !'
                      //     : null,
                      hintText: (user == null) ? 'درباره خودتان (اختیاری)' : _about!,
                      iconData: CupertinoIcons.pencil,
                      maxLines: 4,
                      minLines: 2,
                    ),
                    UserTextFieldWidget(
                      // onSaved: (value) => _website = value,
                      // validator: (value) => (value!.trim().isEmpty)
                      //     ? 'دامنه یا آدرس اینترنتی خود را وارد کنید !'
                      //     : null,
                      hintText: (user == null) ? 'وبسایت (اختیاری)' : _website!,
                      iconData: CupertinoIcons.globe,
                      keyboardType: TextInputType.url,
                      // maxLength: 50,
                    ),
                    */
                        SizedBox(height: screenHeight * 0.05),
                        InkWell(
                          onTap: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();

                              if (_password == _repassword) {
                                _registerUser(context);
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return BottomSheetAlertWidget(
                                        message: 'رمز با تکرار آن مطابقت ندارد!',
                                        height: screenHeight * 0.1);
                                  },
                                );
                              }
                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheetAlertWidget(
                                      message: 'فرم نامعتبر است لطفاً اطلاعات را صحیح وارد کنید!',
                                      height: screenHeight * 0.1);
                                },
                              );
                            }
                          },
                          highlightColor: Colors.transparent,
                          overlayColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                          child: Container(
                            width: screenWidth * 0.5,
                            height: screenHeight * 0.06,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(16)),
                            child: (isProcessing)
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ثبت نام',
                                  style: Theme.of(context).textTheme.button!
                                      .copyWith(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                CupertinoActivityIndicator(
                                  radius: (screenHeight * 0.06) * 0.4,
                                  color: Colors.white,
                                ),
                              ],
                            )
                                : Text(
                              'ثبت نام',
                              style: Theme.of(context).textTheme.button!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipPath(
                    clipper: SineCurveClipper(),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/background_10.jpg'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    // position of curve point1 - half of container width
                    left: (screenWidth / 4) - (screenWidth * (0.24 / 2)),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Container(
                          width: screenWidth * 0.24,
                          height: screenWidth * 0.24,
                          alignment: Alignment.center,
                          child: Shimmer.fromColors(
                            baseColor: Colors.transparent,
                            highlightColor: Theme.of(context).primaryColor,
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
        },
      ),
    );
  }
}
