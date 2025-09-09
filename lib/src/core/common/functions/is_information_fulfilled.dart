import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";

bool isInformationNotFullFilled(UserInfoModel userData) {
  return userData.fullName == null ||
      userData.email == null ||
      userData.address == null ||
      userData.birth == null ||
      userData.gender == null ||
      userData.heightFt == null ||
      userData.heightIn == null ||
      userData.weight == null;
}
