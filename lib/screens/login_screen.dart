import 'package:education/providers/theme_info.dart';
import 'package:education/providers/user_data.dart';
import 'package:education/services/education_api.dart';
import 'package:flutter/material.dart';
import 'package:education/models/user.dart';
import 'package:education/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:education/widgets/user_text_field_widget.dart';
import 'package:education/helpers/preferences.dart';
import 'package:education/helpers/clippers/sine_curve_clipper.dart';
import 'package:provider/provider.dart';

import '../widgets/bottomsheet_alert_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _username, _password, _email;
  bool isProcessing = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    String? key = await EducationApi.postLoginUser(
        {"username": _username!, "password": _password!});

    if (key != null) {
      await EducationPreferences.setUserPreferences(
        _username!,
        _password!,
        _email!,
        key: key,
      );

      Provider.of<UserData>(context, listen: false)
          .setUser(User(_username!, _password!, _email!, key: key));
      Navigator.of(context).pop();
    } else {
      // 400 Bad Request
      // Unable to log in with provided credentials.
      // This field may not be blank.
      // This field is required.
      // Must include username and password.

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const BottomSheetAlertWidget(
            message: 'لطفاً اطلاعات را صحیح وارد کنید!',
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
                          'Login',
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
                          hintText: 'ایمیل',
                          iconData: CupertinoIcons.at,
                          keyboardType: TextInputType.emailAddress,
                          // maxLength: 100,
                        ),
                        UserTextFieldWidget(
                          onSaved: (value) => _username = value,
                          validator: (value) => (value!.trim().length < 5)
                              ? 'نام کاربری بایستی حداقل ۵ کاراکتر باشد !'
                              : null,
                          hintText: 'نام کاربری',
                          iconData: CupertinoIcons.person_alt,
                          // maxLength: 100,
                        ),
                        UserTextFieldWidget(
                          onSaved: (value) => _password = value,
                          validator: (value) => (value!.trim().length < 4)
                              ? 'فیلد رمز بایستی حداقل ۸ کاراکتر داشته باشد !'
                              : null,
                          hintText: 'رمز',
                          iconData: CupertinoIcons.lock,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          isSecure: true,
                          maxLines: 1,
                          // maxLength: 128,
                        ),
                        GestureDetector(
                          onTap: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              _login(context);
                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheetAlertWidget(
                                      message: 'فرم نامعتبر است!',
                                      height: screenHeight * 0.1);
                                },
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.16,
                                vertical: screenWidth * 0.1),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            // height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(16)),
                            child: (isProcessing)
                                ? Row(
                              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ورود',
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
                              'ورود',
                              style: Theme.of(context).textTheme.button!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1)
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
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      },
                      child: Container(
                        height: screenHeight * 0.1,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: Text(
                          'قبلاً ثبت نام نکرده اید؟',
                          style: Theme.of(context).textTheme.headline6!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
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
