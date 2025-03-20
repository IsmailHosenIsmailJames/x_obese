import 'package:o_xbese/src/screens/controller/info_collector/model/all_info_model.dart';

bool isInformationNotFullFilled(AllInfoModel userData) {
  return userData.image == null ||
      userData.fullName == null ||
      userData.email == null ||
      userData.address == null ||
      userData.birth == null ||
      userData.gender == null ||
      userData.heightFt == null ||
      userData.heightIn == null ||
      userData.weight == null;
}
