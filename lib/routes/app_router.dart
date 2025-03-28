import 'package:ca_app/data/models/user_model.dart';
import 'package:ca_app/screens/auth_screens/forgot_screen.dart';
import 'package:ca_app/screens/ca_screens/all_raise_history/all_raise_history_screen.dart';
import 'package:ca_app/screens/ca_screens/customer_allocation/customer_allocation.dart';
import 'package:ca_app/screens/ca_screens/logs_history/logs_history_screen.dart';
import 'package:ca_app/screens/ca_screens/my_client_screens/my_client_screen.dart';
import 'package:ca_app/screens/ca_screens/my_client_screens/view_client_screen.dart';
import 'package:ca_app/screens/ca_screens/my_client_screens/view_document_screen.dart';
import 'package:ca_app/screens/ca_screens/reminders_screen/reminders_screen.dart';
import 'package:ca_app/screens/ca_screens/reminders_screen/view_reminder_screen.dart';
import 'package:ca_app/screens/ca_screens/services_screens/services_screen.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/task_allocation_screen.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/upload_document_screen.dart';
import 'package:ca_app/screens/ca_screens/task_allocation/view_task_screen.dart';
import 'package:ca_app/screens/ca_screens/team_member/team_member_screen.dart';
import 'package:ca_app/screens/ca_screens/team_member/view_team_member_screen.dart';
import 'package:ca_app/screens/help&support_screens/help&support.dart';
import 'package:ca_app/screens/auth_screens/login_screen.dart';
import 'package:ca_app/screens/auth_screens/otp_verification_screen.dart';
import 'package:ca_app/screens/auth_screens/register_screen.dart';
import 'package:ca_app/screens/auth_screens/reset_password_screen.dart';
import 'package:ca_app/screens/ca_screens/ca_dashboard_screen.dart';
import 'package:ca_app/screens/customer_client_screens/customer_dashboard_screen.dart';
import 'package:ca_app/screens/customer_client_screens/hisoty_screen/history_screen.dart';
import 'package:ca_app/screens/customer_client_screens/my_ca_screen/my_ca_screen.dart';
import 'package:ca_app/screens/my_profile_screen/profile_screen.dart';
import 'package:ca_app/screens/customer_client_screens/payment_screen/payment_screen.dart';
import 'package:ca_app/screens/customer_client_screens/request_screen/ca_request_screen.dart';
import 'package:ca_app/screens/customer_client_screens/request_screen/raise_request_screen.dart';
import 'package:ca_app/screens/customer_client_screens/request_screen/request_details_screen.dart';
import 'package:ca_app/screens/customer_client_screens/request_screen/request_screen.dart';
import 'package:ca_app/screens/customer_client_screens/request_screen/your_request_screen.dart';
import 'package:ca_app/screens/customer_client_screens/upload_document/upload_document_screen.dart';
import 'package:ca_app/screens/help&support_screens/help&support_history_screen.dart';
import 'package:ca_app/screens/help&support_screens/help&support_view_screen.dart';
import 'package:ca_app/screens/starting_screens/splash_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/my_clients/my_clients_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/my_services/my_services_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/my_task/my_task_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/my_task/task_view_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/recent_document/recent_document_screen.dart';
import 'package:ca_app/screens/sub_ca_screens/sub_ca_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      // All MODULES COMMON ROUTES
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          var data = state.extra as UserModel;
          return RegisterScreen(
            userData: data,
          );
        },
      ),
      GoRoute(
          path: '/otpVerify',
          builder: (context, state) {
            final email = state.extra != null ? state.extra as String : null;
            return OtpVerificationScreen(
              email: email,
            );
          }),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => ForgotScreen(),
      ),
      GoRoute(
        path: '/resetPassword',
        builder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return ResetPasswordScreen(userId: data['userId']);
        },
      ),

      GoRoute(
        path: '/myProfile',
        builder: (context, state) {
          return ProfileScreen();
        },
      ),
      GoRoute(
          path: '/help&support',
          builder: (context, state) {
            final isLogin = state.extra as bool;
            return HelpAndSupport(
              isLogin: isLogin,
            );
          }),
      GoRoute(
        path: '/help&support_history',
        builder: (context, state) {
          return HelpAndSupportHistoryScreen();
        },
      ),
      GoRoute(
        path: '/view_history',
        builder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return HelpAndSupportViewScreen(
            contactId: data["contactId"],
          );
        },
      ),
      // CA AND SUBCA COMMON MODULE ROUTES
      GoRoute(
        path: '/recent_document',
        builder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return RecentDocumentScreen(
            role: data['role'],
          );
        },
      ),
      // CLIENT AND SUBCA COMMON MODULE ROUTES
      GoRoute(
        path: '/myCa',
        builder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return MyCaScreen(
            caId: data["caId"],
          );
        },
      ),
      // CA,SUBCA AND CLIENT  COMMON MODULE ROUTES
      GoRoute(
          path: '/raise_request',
          builder: (context, state) {
            var userRole = state.extra as Map<String, dynamic>;
            return RaiseRequestScreen(
              userRole: userRole['role'],
            );
          },
          routes: [
            GoRoute(
              path: 'your_request',
              builder: (context, state) {
                return YourRequestScreen();
              },
            ),
            GoRoute(
              path: 'ca_request',
              builder: (context, state) {
                return CaRequestScreen();
              },
            ),
          ]),
      GoRoute(
        path: '/request_details',
        builder: (context, state) {
          var data = state.extra as Map<String, dynamic>;
          return RequestDetailsScreen(
            requestId: data["requestId"],
          );
        },
      ),
      // CUSTOMER MODULE ROUTES
      GoRoute(
          path: '/customer_dashboard',
          builder: (context, state) {
            return CustomerDashboardScreen();
          },
          routes: [
            GoRoute(
              path: 'upload_document',
              builder: (context, state) {
                return UploadDocumentScreen();
              },
            ),
            GoRoute(
              path: 'history',
              builder: (context, state) {
                return HistoryScreen();
              },
            ),
            GoRoute(
              path: 'payment',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return PaymentScreen(
                  caId: data["caId"],
                );
              },
            ),
            GoRoute(
              path: 'request',
              builder: (context, state) {
                return RequestScreen();
              },
            ),
          ]),
      // CA MODULE ROUTES
      GoRoute(
          path: '/ca_dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return CaDashboardScreen();
          },
          routes: [
            GoRoute(
              path: 'services',
              builder: (context, state) {
                return ServicesScreen();
              },
            ),
            GoRoute(
              path: 'my_client',
              builder: (context, state) {
                return MyCAClientScreen();
              },
            ),
            GoRoute(
              path: 'view_client',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return ViewClientScreen(
                  userId: data["userId"],
                );
              },
            ),
            GoRoute(
              path: 'view_document',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return ViewDocumentScreen(
                  userId: data["userId"],
                );
              },
            ),
            GoRoute(
              path: 'team_member',
              builder: (context, state) {
                return TeamMemberScreen();
              },
            ),
            GoRoute(
              path: 'view_team_member',
              builder: (context, state) {
                var userId = state.extra as Map<String, dynamic>;
                return ViewTeamMemberScreen(
                  userId: userId['userId'],
                );
              },
            ),
            GoRoute(
              path: 'customer_allocation',
              builder: (context, state) {
                return CustomerAllocation();
              },
            ),
            GoRoute(
              path: 'task_allocation',
              builder: (context, state) {
                return TaskAllocationScreen();
              },
            ),
            GoRoute(
              path: 'all_raise_history',
              builder: (context, state) {
                return AllRaiseHistoryScreen();
              },
            ),
            GoRoute(
              path: 'view_task',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return ViewTaskScreen(taskId: data['taskId']);
              },
            ),
            GoRoute(
              path: 'upload_task_document',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return UploadTaskDocumentScreen(
                  taskId: data["taskId"],
                );
              },
            ),
            GoRoute(
              path: 'logs_history',
              builder: (context, state) {
                var data = state.extra != null
                    ? state.extra as Map<String, dynamic>
                    : {};
                return LogsHistoryScreen(
                  uponId: data["uponId"],
                );
              },
            ),
            GoRoute(
              path: 'reminders',
              builder: (context, state) {
                return RemindersScreen();
              },
            ),
            GoRoute(
              path: 'view_reminder',
              builder: (context, state) {
                var data = state.extra as Map<String, dynamic>;
                return ViewReminderScreen(reminderId: data["reminderId"]);
              },
            )
          ]),
      // SUBCA MODULE ROUTES
      GoRoute(
          path: '/subca_dashboard',
          builder: (context, state) {
            return SubCaDashboardScreen();
          },
          routes: [
            GoRoute(
              path: 'my_service',
              builder: (context, state) {
                return MyServicesScreen();
              },
            ),
            GoRoute(
              path: 'my_client',
              builder: (context, state) {
                return MyClientsScreen();
              },
            ),
            GoRoute(
              path: 'my_task',
              builder: (context, state) {
                return MyTaskScreen();
              },
            ),
            GoRoute(
              path: 'task_view',
              builder: (context, state) {
                return TaskViewScreen();
              },
            ),
          ]),
    ]);
