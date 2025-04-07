import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
            child: Text('/api/marathon/v1/user'),
          ),
          ElevatedButton(
            onPressed: () async {
              print(await getAccessToken());
              print(await getRefreshToken());

              try {
                DioClient dioClient = DioClient(baseAPI);
                final response = await dioClient.doRefreshToken(
                  (await getRefreshToken())!,
                );
                log(response.toString());
                print(await getAccessToken());
                print(await getRefreshToken());
              } on DioException catch (e) {
                printResponse(e.response!);
              }
            },
            child: Text('Do Refresh Tokens'),
          ),
        ],
      ),
    );
  }
}
