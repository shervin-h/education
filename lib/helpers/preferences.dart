import 'package:education/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EducationPreferences {
  static final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();

  static Future<void> setUserPreferences(
    String userName,
    String password,
    String email,
    {int? id,
    String? avatar,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? about,
    String? website,

    required String key,
    // String? accessToken,
    // String? refreshToken,
  }) async {
    final SharedPreferences preferences = await sharedPreferences;


    await preferences.setString('username', userName);
    await preferences.setString('password', password);
    await preferences.setString('email', email);
    await preferences.setString('key', key);


    if(id != null) {
      await preferences.setInt('id', id);
    }

    if (avatar != null) {
      await preferences.setString('avatar', avatar);
    }

    if (firstName != null) {
      await preferences.setString('firstname', firstName);
    }

    if (lastName != null) {
      await preferences.setString('lastname', lastName);
    }

    if (phoneNumber != null) {
      await preferences.setString('phone', phoneNumber);
    }

    if (about != null) {
      await preferences.setString('about', about);
    }

    if (website != null) {
      await preferences.setString('website', website);
    }

    // if (accessToken != null) {
    //   await preferences.setString('accessToken', accessToken);
    // }
    //
    // if (refreshToken != null) {
    //   await preferences.setString('refreshToken', refreshToken);
    // }
  }

  static Future<User?> getUserPreferences() async {
    final SharedPreferences preferences = await sharedPreferences;

    int? id = preferences.getInt('id');
    String? userName = preferences.getString('username');
    String? email = preferences.getString('email');
    String? password = preferences.getString('password');
    String? avatar = preferences.getString('avatar');
    String? firstName = preferences.getString('firstname');
    String? lastName = preferences.getString('lastname');
    String? phoneNumber = preferences.getString('phone');
    String? about = preferences.getString('about');
    String? website = preferences.getString('website');

    String? key = preferences.getString('key');
    // String? accessToken = preferences.getString('accessToken');
    // String? refreshToken = preferences.getString('refreshToken');

    if (userName != null && password != null && email != null && key != null) {
      return User(userName, password, email,
          id: id,
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
          phoneNumber: phoneNumber,
          about: about,
          website: website,

          key: key,
          // accessToken: accessToken,
          // refreshToken: refreshToken,
      );
    }
    return null;
  }

  static Future<void> deleteUserPreferences() async {
    final SharedPreferences preferences = await EducationPreferences.sharedPreferences;

    await preferences.remove('username');
    await preferences.remove('password');
    await preferences.remove('email');
    await preferences.remove('key');

    if (preferences.containsKey('id')){
      await preferences.remove('id');
    }

    if (preferences.containsKey('avatar')){
      await preferences.remove('avatar');
    }

    if (preferences.containsKey('firstname')){
      await preferences.remove('firstname');
    }

    if (preferences.containsKey('lastname')){
      await preferences.remove('lastname');
    }

    if (preferences.containsKey('phone')){
      await preferences.remove('phone');
    }

    if (preferences.containsKey('about')){
      await preferences.remove('about');
    }

    if (preferences.containsKey('website')){
      await preferences.remove('website');
    }
  }

  static Future<void> setSettingsPreferences(
      {bool? isDark, String? fontFamily}) async {
    final SharedPreferences preferences = await sharedPreferences;

    if(isDark != null) {
      await preferences.setBool('is_dark', isDark);
    }

    if (fontFamily != null) {
      await preferences.setString('font_family', fontFamily);
    }
  }

  static Future<Map<String, dynamic>> getSettingsPreferences() async {
    final SharedPreferences preferences = await sharedPreferences;

    bool? isDark = preferences.getBool('is_dark');
    String? fontFamily = preferences.getString('font_family');

    Map<String, dynamic> settingsAsMap = {};

    if (isDark != null) {
      settingsAsMap['is_dark'] = isDark;
    }

    if (fontFamily != null) {
      settingsAsMap['font_family'] = fontFamily;
    }

    return settingsAsMap;
  }
}
