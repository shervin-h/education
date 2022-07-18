import 'package:education/models/course.dart';

class Teacher {
  Teacher(this.teacherId, this.userId,this.firstName, this.lastName,
      {this.avatar, this.about, this.website, this.courses});

  int teacherId;
  int userId;
  String firstName;
  String lastName;
  String? avatar;
  String? about;
  String? website;
  List<Course>? courses;
}