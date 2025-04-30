import 'package:x_obese/src/screens/controller/info_collector/model/all_info_model.dart';

bool isInformationNotFullFilled(AllInfoModel userData) {
  return userData.fullName == null ||
      userData.email == null ||
      userData.address == null ||
      userData.birth == null ||
      userData.gender == null ||
      userData.heightFt == null ||
      userData.heightIn == null ||
      userData.weight == null;
}
