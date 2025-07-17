import 'package:pixelmator/database/animationStep.dart';

import 'entity.dart';

class PixelAnimation extends Entity {
  String name;
  List<AnimationStep> steps;
  int columns, rows;
  String userId; //firebase
  DateTime creationDate;
  bool published;
  ColorValues backgroundColor;

  PixelAnimation(this.name, this.steps, this.columns, this.rows, this.userId,
      this.creationDate, this.published, this.backgroundColor);

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "steps": steps.map((e) => e.toJson()).toList(),
        "columns": columns,
        "rows": rows,
        "userId": userId,
        "creationDate": creationDate,
        "published": published,
        "backgroundColor": backgroundColor.toJson()
      };

  @override
  static PixelAnimation fromJson(Map<dynamic, dynamic> v) {
    var key1;
    List<AnimationStep> steps = [];
    String delay;
    for (key1 in v['steps']) {
      steps.add(AnimationStep.fromJson(key1));
    }

    return PixelAnimation(
        v['name'],
        steps,
        v['columns'],
        v['rows'],
        v['userId'],
        v['creationDate'].toDate(),
        v["published"],
        ColorValues.fromJson(v["backgroundColor"]));
  }
}
