import "dart:convert";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:x_obese/src/screens/activity/models/activity_types.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/activity/models/activity_status.dart";

class AppExtraCodec extends Codec<Object?, Object?> {
  const AppExtraCodec();

  @override
  Converter<Object?, Object?> get decoder => const _AppExtraDecoder();

  @override
  Converter<Object?, Object?> get encoder => const _AppExtraEncoder();
}

class _AppExtraEncoder extends Converter<Object?, Object?> {
  const _AppExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    if (input is UserInfoModel) {
      return {"__type": "UserInfoModel", "data": input.toMap()};
    }
    if (input is CreateWorkoutPlanModel) {
      return {"__type": "CreateWorkoutPlanModel", "data": input.toMap()};
    }
    if (input is GetWorkoutPlans) {
      return {"__type": "GetWorkoutPlans", "data": input.toMap()};
    }
    if (input is GetBlogModel) {
      return {"__type": "GetBlogModel", "data": input.toMap()};
    }
    if (input is ActivityType) {
      return {"__type": "ActivityType", "data": input.name};
    }
    if (input is MarathonUserModel) {
      return {"__type": "MarathonUserModel", "data": input.toMap()};
    }
    if (input is MarathonModel) {
      return {"__type": "MarathonModel", "data": input.toMap()};
    }
    if (input is FullMarathonDataModel) {
      return {"__type": "FullMarathonDataModel", "data": input.toMap()};
    }
    if (input is PositionNodes) {
      return {"__type": "PositionNodes", "data": input.toMap()};
    }
    if (input is ActivityStatus) {
      return {"__type": "ActivityStatus", "data": input.name};
    }
    if (input is Position) {
      return {
        "__type": "Position",
        "data": input.toJson(),
      };
    }

    if (input is Map) {
      return input.map((key, value) => MapEntry(key, convert(value)));
    }
    if (input is List) {
      return input.map(convert).toList();
    }

    return input;
  }
}

class _AppExtraDecoder extends Converter<Object?, Object?> {
  const _AppExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    if (input is Map) {
      final type = input["__type"];
      if (type != null) {
        final data = input["data"];
        switch (type) {
          case "UserInfoModel":
            return UserInfoModel.fromMap(Map<String, dynamic>.from(data));
          case "CreateWorkoutPlanModel":
            return CreateWorkoutPlanModel.fromMap(
              Map<String, dynamic>.from(data),
            );
          case "GetWorkoutPlans":
            return GetWorkoutPlans.fromMap(Map<String, dynamic>.from(data));
          case "GetBlogModel":
            return GetBlogModel.fromMap(Map<String, dynamic>.from(data));
          case "ActivityType":
            return ActivityType.values.byName(data as String);
          case "MarathonUserModel":
            return MarathonUserModel.fromMap(Map<String, dynamic>.from(data));
          case "MarathonModel":
            return MarathonModel.fromMap(Map<String, dynamic>.from(data));
          case "FullMarathonDataModel":
            return FullMarathonDataModel.fromMap(
              Map<String, dynamic>.from(data),
            );
          case "PositionNodes":
            return PositionNodes.fromMap(Map<String, dynamic>.from(data));
          case "ActivityStatus":
            return ActivityStatus.values.byName(data as String);
          case "Position":
            return Position.fromMap(Map<String, dynamic>.from(data));
        }
      }
      return input.map((key, value) => MapEntry(key, convert(value)));
    }

    if (input is List) {
      return input.map(convert).toList();
    }

    return input;
  }
}
