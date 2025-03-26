import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:o_xbese/src/apis/apis_url.dart';
import 'package:o_xbese/src/apis/middleware/jwt_middleware.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
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
    );
  }
}
