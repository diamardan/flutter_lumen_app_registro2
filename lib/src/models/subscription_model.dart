import 'package:lumen_app_registro/src/constants/constants.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';

final school = AppConstants.fsCollectionName;

class Subscription {
  String careerTopic;
  String gradeTopic;
  String groupTopic;
  String turnTopic;
  String schoolTopic;

  Subscription(
      {this.careerTopic,
      this.gradeTopic,
      this.groupTopic,
      this.turnTopic,
      this.schoolTopic});

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        careerTopic: json["career_topic"],
        gradeTopic: json["grade_topic"],
        groupTopic: json["group_topic"],
        turnTopic: json["turn_topic"],
        schoolTopic: json["school_topic"],
      );

  factory Subscription.fromRegistration(Registration reg) {
    String career = _replaceChars(reg.career.toLowerCase());
    String grade = "grade-${reg.grade}";
    String group = "group-${reg.group.toLowerCase()}";
    String turn = _replaceChars(reg.turn.toLowerCase());

    return Subscription(
        careerTopic: career ?? "none",
        gradeTopic: grade ?? "none",
        groupTopic: group ?? "none",
        turnTopic: turn ?? "none",
        schoolTopic: school);
  }

  Map<String, dynamic> toJson() => {
        "career_topic": careerTopic,
        "grade_topic": gradeTopic,
        "group_topic": groupTopic,
        "turn_topic": turnTopic,
        "school_topic": schoolTopic,
      };
  List<String> toList() =>
      [careerTopic, gradeTopic, groupTopic, turnTopic, schoolTopic];
}

String _replaceChars(word) {
  word = word.replaceAll(RegExp(' +'), "-");
  word = word.replaceAll("á", "a");
  word = word.replaceAll("é", "e");
  word = word.replaceAll("í", "i");
  word = word.replaceAll("ó", "o");
  word = word.replaceAll("ú", "u");

  return word;
}
