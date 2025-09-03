import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/adapters.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/banners/model/banner_model.dart";

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

List<BannerModel> bannersModelList = [];

class _BannersState extends State<Banners> {
  @override
  void initState() {
    initCall();
    super.initState();
  }

  void initCall() async {
    List bannersFormDB = Hive.box("user").get("banners", defaultValue: []);

    if (bannersFormDB.isNotEmpty) {
      bannersModelList =
          bannersFormDB
              .map((e) => BannerModel.fromMap(Map<String, dynamic>.from(e)))
              .toList();
    }

    setState(() {});

    final response = await DioClient(baseAPI).dio.get(banners);
    if (response.statusCode == 200) {
      List data = response.data["data"] ?? [];
      bannersModelList =
          data
              .map((e) => BannerModel.fromMap(Map<String, dynamic>.from(e)))
              .toList();
    }

    await Hive.box(
      "user",
    ).put("banners", bannersModelList.map((e) => e.toMap()).toList());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 10, right: 10),
        scrollDirection: Axis.horizontal,
        itemCount: bannersModelList.length,
        itemBuilder: (context, index) {
          BannerModel current = bannersModelList[index];
          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: MyAppColors.third,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: MyAppColors.transparentGray),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                height: 120,
                width: 240,
                fit: BoxFit.cover,
                imageUrl: current.imagePath ?? "",
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: MyAppColors.primary,
                    ),
                  );
                },

                errorWidget: (context, url, error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 50,
                          color: MyAppColors.transparentGray.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        current.title != null
                            ? Text(
                              current.title ?? "",
                              style: TextStyle(color: MyAppColors.third),
                            )
                            : Text(
                              "No Title",
                              style: TextStyle(color: MyAppColors.third),
                            ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
