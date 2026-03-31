import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:x_obese/src/core/common/functions/is_information_fulfilled.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/activity/live_activity_page.dart";
import "package:x_obese/src/screens/activity/live_activity_resume_page.dart";
import "package:x_obese/src/screens/activity/models/activity_types.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/activity/workout_page.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";
import "package:x_obese/src/screens/auth/login/otp_page.dart";
import "package:x_obese/src/screens/auth/login/success_page.dart";
import "package:x_obese/src/screens/blog/blog_details_view.dart";
import "package:x_obese/src/screens/blog/blog_list_view.dart";
import "package:x_obese/src/screens/blog/model/get_blog_model.dart";
import "package:x_obese/src/screens/marathon/details_marathon/marathon_details_view.dart";
import "package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart";
import "package:x_obese/src/screens/marathon/leader_board/leader_board_view.dart";
import "package:x_obese/src/screens/marathon/models/marathon_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/screens/create_workout_plan/create_workout_plan.dart";
import "package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/info_collector/info_collector.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:x_obese/src/screens/intro/intro_page.dart";
import "package:x_obese/src/screens/navs/naves_page.dart";
import "package:x_obese/src/screens/workout_plan_overview/workout_plan_overview_screen.dart";
import "package:x_obese/src/screens/marathon/show_search_result/show_search_result.dart";
import "package:x_obese/src/screens/home/statistics_overview_screen.dart";
import "package:x_obese/src/screens/home/workout_history_screen.dart";
import "package:dio/dio.dart" as dio;

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter router({
    List<PositionNodes>? positionNodes,
    bool? isPaused,
    ActivityType? activityType,
    required AuthBloc authBloc,
  }) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: "/",
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const SizedBox.shrink(), // Should be handled by redirect
          redirect: (context, state) {
            UserInfoModel? userInfoModel = authBloc.userInfoModel();
            
            if (positionNodes != null && isPaused != null) {
              return "/workout";
            }
            if (userInfoModel == null) {
              return "/intro";
            }
            if (isInformationNotFullFilled(userInfoModel)) {
              return userInfoModel.isGuest ? "/home" : "/infoCollector";
            }
            if (UserDB.accessToken() == null && UserDB.refreshToken() == null) {
              return "/login";
            }
            return "/home";
          },
        ),
        GoRoute(
          path: "/intro",
          builder: (context, state) => const IntroPage(),
        ),
        GoRoute(
          path: "/login",
          builder: (context, state) => const LoginSignupPage(),
        ),
        GoRoute(
          path: "/home",
          builder: (context, state) => const NavesPage(),
        ),
        GoRoute(
          path: "/infoCollector",
          builder: (context, state) {
            final extra = state.extra as UserInfoModel?;
            if (extra != null) {
              return InfoCollector(initialData: extra);
            }
            final String? info = Hive.box("user").get("info");
            return InfoCollector(
              initialData: info != null ? UserInfoModel.fromJson(info) : null,
            );
          },
        ),
        GoRoute(
          path: "/workout",
          builder: (context, state) {
            return NavesPage(
              autoNavToWorkout: true,
              isPaused: isPaused,
              positionNodes: positionNodes,
              activityType: activityType,
            );
          },
        ),
        GoRoute(
          path: "/otp",
          builder: (context, state) {
            final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
            return OtpPage(
              isSignup: extra["isSignup"] as bool,
              phone: extra["phone"] as String,
              response: extra["response"] as dio.Response,
            );
          },
        ),
        GoRoute(
          path: "/success",
          builder: (context, state) => const LoginSuccessPage(),
        ),
        GoRoute(
          path: "/create-workout",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CreateWorkoutPlan(
              createWorkoutPlanModel: extra?["createWorkoutPlanModel"] as CreateWorkoutPlanModel?,
              id: extra?["id"] as String?,
            );
          },
        ),
        GoRoute(
          path: "/workout-overview",
          builder: (context, state) {
            final extra = state.extra as List<GetWorkoutPlans>;
            return WorkoutPlanOverviewScreen(getWorkoutPlansList: extra);
          },
        ),
        GoRoute(
          path: "/blogs",
          builder: (context, state) => const BlogListView(),
        ),
        GoRoute(
          path: "/blog-details",
          builder: (context, state) {
            final extra = state.extra as GetBlogModel;
            return BlogDetailsView(blogData: extra);
          },
        ),
        GoRoute(
          path: "/live-activity-resume",
          builder: (context, state) => const LiveActivityResumePage(),
        ),
        GoRoute(
          path: "/live-activity",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return LiveActivityPage(
              workoutType: extra["workoutType"] as ActivityType,
              initialLatLon: extra["initialLatLon"],
              marathonUserModel: extra["marathonUserModel"],
              marathonData: extra["marathonData"],
            );
          },
        ),
        GoRoute(
          path: "/marathon-details",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return MarathonDetailsView(
              marathonData: extra["marathonData"] as MarathonModel,
              isVirtual: extra["isVirtual"] as bool,
            );
          },
        ),
        GoRoute(
          path: "/leaderboard",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return LeaderBoardView(
              title: extra["title"] as String,
              leaderboardUsers:
                  extra["leaderboardUsers"] as List<MarathonUserModel>,
              marathonData: extra["marathonData"] as FullMarathonDataModel,
            );
          },
        ),
        GoRoute(
          path: "/activity",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return ActivityPage(
              marathonUserModel:
                  extra?["marathonUserModel"] as MarathonUserModel?,
              marathonData: extra?["marathonData"] as FullMarathonDataModel?,
            );
          },
        ),
        GoRoute(
          path: "/statistics-overview",
          builder: (context, state) => const StatisticsOverviewScreen(),
        ),
        GoRoute(
          path: "/workout-history",
          builder: (context, state) => const WorkoutHistoryScreen(),
        ),
        GoRoute(
          path: "/search-result",
          builder: (context, state) {
            final extra = state.extra as List<MarathonUserModel>;
            return ShowSearchResult(marathonUserList: extra);
          },
        ),
      ],
    );
  }
}
