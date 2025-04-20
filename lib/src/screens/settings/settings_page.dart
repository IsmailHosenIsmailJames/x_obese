import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';
import 'package:x_obese/src/screens/marathon/leader_board/leader_board_view.dart';

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
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              log(prefs.getString('access_token').toString());
            },
            child: Text('Get access token'),
          ),
        ],
      ),
    );
  }
}
