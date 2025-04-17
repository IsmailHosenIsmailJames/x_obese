import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';
import 'package:x_obese/src/screens/marathon/leader_board/leader_board_view.dart';
import 'package:x_obese/src/screens/marathon/leader_board/model/leaderboard_user_model.dart';

class SettingsPage extends StatefulWidget {
  final PageController pageController;
  const SettingsPage({super.key, required this.pageController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              DioClient dioClient = DioClient(baseAPI);
              try {
                final response = await dioClient.dio.get(
                  '/api/marathon/v1/user',
                );
                printResponse(response);
              } on DioException catch (e) {
                log(e.message.toString());
                printResponse(e.response!);
              }
            },
            child: const Text('/api/marathon/v1/user'),
          ),
          ElevatedButton(
            onPressed: () async {
              log((await getAccessToken()) ?? 'Not Found');
              log((await getRefreshToken()) ?? 'Not Found');

              try {
                DioClient dioClient = DioClient(baseAPI);
                final response = await dioClient.doRefreshToken(
                  (await getRefreshToken())!,
                );
                log(response.toString());
                log((await getAccessToken()) ?? 'Not Found');
                log((await getRefreshToken()) ?? 'Not Found');
              } on DioException catch (e) {
                printResponse(e.response!);
              }
            },
            child: const Text('Do Refresh Tokens'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(
                () => LeaderBoardView(
                  title: 'February 5k Challenge Run',
                  leaderboardUsers: [
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 1,

                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Tawhid',
                      distance: 10,
                      rank: 2,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/5180/c727/4a468ba221dccc98237c5b89acc690bd?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=FNZ1LO8~Q6Nndb3twfG85u00Ms-x4jOLt3hm~gb7gF8wMl2EpCUlusPvb~1y3Jgaqigtn5q-YJLc03QkDj-Ube1BklsDV3pHYIiArSR8dxEYNY8ddnNCONGm7t6UKepHWJG-WlSlbCuyUwPc~~3~JYbSf-RMBIoAMeIoSau3~KABTHkRshyOgw1BLLzfY8c~zsrqcmK~XpaFfcMGKZExQR7AWNcrai2DLrb31lYG569uzjqDaXffrhwkQ3wWwGiQftj2gvJOKpByjU7LqYNdiG1y7WtFmo31pZmCQwYGLxokwGj-oEY7AVP5Yrqe0SoK2Dwqedag2WUDQLtjEeWQ1A__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Ismail',
                      distance: 10,
                      rank: 3,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/6239/febb/788d15352e5535fbad6deaf92bbadfa8?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=FyHyo2GGM8m7mgrabV2CeihtmavJHtBd1MaZB4v5FE5LOKO-NRGesr9hAlDgldw7zGH3WK2L4RrZQT-ieiQ9ywk5IZ3CpGybWebsdfwHgga16Stzw~R85FGjKV9~SsreIFtuXT5G1MWegHEDOZ4WZ92pbOPb65I-NPdFaQhvOJUpwSkEa4SaMCn-zFGaS5JbxatjR-R7tqJoKlJTKkTiyYz6sKTeEBASAvMwLVIuPf1uK0~bs1JbXCT5WrnYFmec8KJJSPjw0kbjbSpB2KHKljHXMNuq44Oja5y4PzvzpsfvTiUhq8kVhtrD9XhRg4HKMN2smhm3ZwIz9bmiM8AHOA__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 4,
                      isIncreasingRank: false,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/8cac/66ed/ac7e9cc006e377a554341d67f0d9b385?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=YiIAKToVO8n~aFdpt47arbK1sPN3xTuFO0Sq9xDKQjKE4JpzFy2WRfjA76zmSv0tM9s7kr7x2q0kDb-jIO7rOPWBb0vvdiX-HnTvJjGCCiNM5qIZ31Aqk5ocTqloBKxx8J0rgtH9t1EL340Vva30zkJYpKnXD6MOPCodaI4OAqTCSbneVeAD11VQZfS~66acMsejATcIpNsKb189HEIkl5Z5CudOtF8jgEiKi894~hFe-cs-BgnwD539uWfhb~Zy7tsEE6po734svuyGvW1hbNXuCB~b72If2m0LpeNeiavmVMGGN3jg6MUKCPsNEW1f2x-iHdJjfqvaZv-WS2W1Fw__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 5,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 6,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 7,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 8,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 9,
                      isIncreasingRank: false,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      isIncreasingRank: true,
                      rank: 10,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                    LeaderboardUserModel(
                      name: 'Earteza',
                      distance: 10,
                      rank: 11,
                      isIncreasingRank: true,
                      imageUrl:
                          'https://s3-alpha-sig.figma.com/img/43fc/587a/4335a7ba37c44ce7a668ca5278d6e2d5?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=lywnrezQ5Ap1lF5Z-gtEAeIh~OXUQujPV7LLeuYiMoFUWh39MW7jMluPgRQYTl8lt7dV0fJ0v24J1E~W-1~et0hvSlnkcuFBa6ajriLhp2oiwPR6bSmyp2u0h9pcSQvZzIR7JXmTK7q1YWt4KwIXutRvXM935Gtrl8pSWPbhXhf6DiF6VXfWdq0bCGBBGEiIUf7Lk5oHD~9W4xGmITuP0qryhqHCbLO534NkpI4~tFswOOhSgHHLW4kRl2mIY2W~GobPCaxYiIyzUNTkcGFuYllIRwm5zUG3rpDai7benJvFQNS-QXSTrsUSSOp3Q9QRD3J~OKzto4u9htjFu5AItg__',
                      duration: 6000000,
                    ),
                  ],
                  pageController: widget.pageController,
                ),
              );
            },
            child: const Text('Go To Leaderboard'),
          ),
        ],
      ),
    );
  }
}
