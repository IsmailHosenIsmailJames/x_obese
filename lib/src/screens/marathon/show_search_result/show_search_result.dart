import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x_obese/src/screens/marathon/models/marathon_user_model.dart';
import 'package:x_obese/src/theme/colors.dart';

class ShowSearchResult extends StatefulWidget {
  final List<MarathonUserModel> marathonUserList;
  const ShowSearchResult({super.key, required this.marathonUserList});

  @override
  State<ShowSearchResult> createState() => _ShowSearchResultState();
}

class _ShowSearchResultState extends State<ShowSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Result'), centerTitle: true),
      body: ListView.builder(
        itemCount: widget.marathonUserList.length,
        itemBuilder: (context, index) {
          final marathonUser = widget.marathonUserList[index];
          return ListTile(
            leading: GestureDetector(
              onTap: () {
                if (marathonUser.user?.imagePath != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    marathonUser.user!.imagePath!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 300,
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 340,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: MyAppColors.mutedGray,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child:
                      marathonUser.user?.imagePath == null
                          ? Icon(Icons.person, color: MyAppColors.mutedGray)
                          : CachedNetworkImage(
                            imageUrl: marathonUser.user!.imagePath!,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),
            title: Text(marathonUser.user?.fullName ?? 'Unknown'),
            subtitle: Text(
              "Distance: ${marathonUser.distanceKm ?? '0'},  Duration: ${marathonUser.durationMs?.toString() ?? '0'}",
              style: TextStyle(fontSize: 14, color: MyAppColors.mutedGray),
            ),
          );
        },
      ),
    );
  }
}
