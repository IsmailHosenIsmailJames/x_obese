import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/marathon/leader_board/model/leaderboard_user_model.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';

class LeaderBoardView extends StatefulWidget {
  final String title;
  final PageController pageController;
  final List<LeaderboardUserModel> leaderboardUsers;

  const LeaderBoardView({
    super.key,
    required this.title,
    required this.leaderboardUsers,
    required this.pageController,
  });
  @override
  State<LeaderBoardView> createState() => _LeaderBoardViewState();
}

class _LeaderBoardViewState extends State<LeaderBoardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  getBackbutton(context, () {
                    Get.back();
                  }),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Marathon Program',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Gap(30),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.leaderboardUsers.length > 1)
                      SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: MyAppColors.second,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.leaderboardUsers[1].imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: const Text(
                                        '2',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(widget.leaderboardUsers[1].name),
                            Text(
                              '${widget.leaderboardUsers[1].distance} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: MyAppColors.mutedGray,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.leaderboardUsers.isNotEmpty)
                      SizedBox(
                        child: Column(
                          children: [
                            SvgPicture.string(
                              '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M17 22H7C6.59 22 6.25 21.66 6.25 21.25C6.25 20.84 6.59 20.5 7 20.5H17C17.41 20.5 17.75 20.84 17.75 21.25C17.75 21.66 17.41 22 17 22Z" fill="#047CEC"/>
<path d="M20.3502 5.52004L16.3502 8.38004C15.8202 8.76004 15.0602 8.53004 14.8302 7.92004L12.9402 2.88004C12.6202 2.01004 11.3902 2.01004 11.0702 2.88004L9.17022 7.91004C8.94022 8.53004 8.19022 8.76004 7.66022 8.37004L3.66022 5.51004C2.86022 4.95004 1.80022 5.74004 2.13022 6.67004L6.29022 18.32C6.43022 18.72 6.81022 18.98 7.23022 18.98H16.7602C17.1802 18.98 17.5602 18.71 17.7002 18.32L21.8602 6.67004C22.2002 5.74004 21.1402 4.95004 20.3502 5.52004ZM14.5002 14.75H9.50022C9.09022 14.75 8.75022 14.41 8.75022 14C8.75022 13.59 9.09022 13.25 9.50022 13.25H14.5002C14.9102 13.25 15.2502 13.59 15.2502 14C15.2502 14.41 14.9102 14.75 14.5002 14.75Z" fill="#047CEC"/>
</svg>
''',
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: MyAppColors.second,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.leaderboardUsers[0].imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: const Text(
                                        '1',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(widget.leaderboardUsers[0].name),
                            Text(
                              '${widget.leaderboardUsers[0].distance} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: MyAppColors.mutedGray,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.leaderboardUsers.length > 2)
                      SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),

                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: MyAppColors.second,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          widget.leaderboardUsers[2].imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: const Text(
                                        '3',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(widget.leaderboardUsers[2].name),
                            Text(
                              '${widget.leaderboardUsers[2].distance} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: MyAppColors.mutedGray,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(10),
              if (widget.leaderboardUsers.length > 3)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.leaderboardUsers.length - 3,
                    itemBuilder: (context, index) {
                      LeaderboardUserModel user =
                          widget.leaderboardUsers[index + 3];
                      return Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          children: [
                            Text('${index + 4}'.padLeft(2, '0')),
                            const Gap(20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CircleAvatar(
                                radius: 16,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget
                                          .leaderboardUsers[index + 2]
                                          .imageUrl,
                                ),
                              ),
                            ),
                            const Gap(12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name),
                                Text(
                                  '${user.distance} km',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MyAppColors.mutedGray,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (user.isIncreasingRank != null)
                              SvgPicture.string(
                                user.isIncreasingRank == true
                                    ? '''<svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10.5179 0.5L3.48207 0.5C1.93849 0.5 0.976748 2.17443 1.75451 3.50774L5.27244 9.53847C6.0442 10.8615 7.9558 10.8615 8.72756 9.53847L12.2455 3.50774C13.0232 2.17443 12.0615 0.500001 10.5179 0.5Z" fill="#3BA332"/>
</svg>
'''
                                    : '''<svg width="14" height="13" viewBox="0 0 14 13" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M10.5179 0.5L3.48207 0.5C1.93849 0.5 0.976748 2.17443 1.75451 3.50774L5.27244 9.53847C6.0442 10.8615 7.9558 10.8615 8.72756 9.53847L12.2455 3.50774C13.0232 2.17443 12.0615 0.500001 10.5179 0.5Z" fill="#E0554D"/>
</svg>
''',
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
