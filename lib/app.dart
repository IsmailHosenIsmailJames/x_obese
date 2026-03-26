import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:x_obese/src/core/router/app_router.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/theme/colors.dart";

import "src/screens/activity/models/activity_types.dart";

class App extends StatefulWidget {
  final List<PositionNodes>? positionNodes;
  final bool? isPaused;
  final ActivityType? activityType;
  const App({super.key, this.positionNodes, this.isPaused, this.activityType});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final PageTransitionsTheme pageTransitionsTheme =
        const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        );

    final goRouter = AppRouter.router(
      positionNodes: widget.positionNodes,
      isPaused: widget.isPaused,
      activityType: widget.activityType,
      authBloc: context.read<AuthBloc>(),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      theme: ThemeData(
        pageTransitionsTheme: pageTransitionsTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyAppColors.third,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: MyAppColors.primary,
        fontFamily: "Lexend",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.all(10),
            backgroundColor: MyAppColors.second,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
    );
  }
}
