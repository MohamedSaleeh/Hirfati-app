import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'DashBoard/admin_dashboard.dart';
import 'core/models/order.dart';
import 'features/Client/Addresses/domain/models/address_model.dart';
import 'features/Client/Addresses/presentation/screens/add_address_screen.dart';
import 'features/Client/Addresses/presentation/screens/edit_address_screen.dart';
import 'features/Client/Addresses/presentation/screens/saved_addresses_screen.dart';
import 'features/Client/pyment_methods/presentation/screens/add_payment_method_screen.dart';
import 'features/Client/pyment_methods/presentation/screens/payment_methods_screen.dart';
import 'features/Client/worker_profile_details/presentation/screens/worker_profile_details_screen.dart';
import 'features/Worker/account_settings/presentation/screens/account_settings_screen.dart';
import 'features/Worker/categories_pricing/presentation/screens/categories_pricing_screen.dart';
import 'features/Worker/earnings/presentation/screens/withdrawal_history_screen.dart';
import 'features/Worker/earnings/presentation/withdraw/screens/withdraw_screen.dart';
import 'features/Worker/identity_verification/presentation/screens/identity_verification_screen.dart';
import 'features/Worker/work_gallery/presentation/screens/add_work_screen.dart';
import 'features/Worker/worker_home/domain/models/worker_order.dart';
import 'features/Worker/worker_home/presentation/screens/order_details_screen.dart';
import 'features/Worker/worker_profile/presentation/screens/worker_profile_screen.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/Client/client_navigation/presentation/screens/client_main_screen.dart';
import 'core/presentation/screens/home_screen_worker.dart';
import 'features/auth/domain/models/auth_form_state.dart';
import 'features/auth/presentation/providers/auth_controller.dart';
import 'features/Client/completeProfile/presentation/providers/profile_setup_controller.dart';
import 'features/Client/completeProfile/presentation/screens/complete_profile_screen.dart';
import 'features/Client/profile/presentation/screens/edit_profile_screen.dart';
import 'features/Worker/complete_profile/presentation/screens/complete_professional_profile_screen.dart';
import 'features/Client/client_navigation/presentation/providers/client_navigation_provider.dart';
import 'features/Client/create_order/presentation/screens/create_order_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/help_support/presentation/screens/contact_us_screen.dart';
import 'features/help_support/presentation/screens/faq_screen.dart';
import 'features/help_support/presentation/screens/help_support_screen.dart';
import 'features/notification_settings/presentation/screens/notification_settings_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';
import 'features/payment/presentation/screens/payment_success_screen.dart';
import 'features/review/presentation/screens/review_screen.dart';
import 'features/wallet/presentation/screens/wallet_screen.dart';
import 'translations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  var authStatus = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: kIsWeb ? '/admin' : '/',
    redirect: (context, state) async {
      final currentRoute = state.matchedLocation;

      if (kIsWeb) {
        if (currentRoute == "/forgot-password" ||
            currentRoute == "/reset-password") {
          return null;
        }

        if (authStatus.isLoading) {
          return currentRoute == "/splash" ? null : "/splash";
        }

        final isAuthenticated = authStatus.when(
          data: (status) => status == AuthStatus.authenticated,
          loading: () => false,
          error: (error, stackTrace) => false,
        );

        if (!isAuthenticated) {
          return currentRoute == "/auth" ? null : "/auth";
        }

        try {
          final isAdmin = await _currentWebUserIsAdmin();
          if (!isAdmin) return currentRoute == '/admin' ? null : '/admin';
        } catch (_) {
          return currentRoute == '/admin' ? null : '/admin';
        }

        return currentRoute == '/admin' ? null : '/admin';
      }

      if (currentRoute == '/admin') {
        return '/';
      }

      if (authStatus.isLoading) {
        return "/splash";
      }

      final isAuthenticated = authStatus.when(
        data: (status) => status == AuthStatus.authenticated,
        loading: () => false,
        error: (error, stackTrace) => false,
      );

      final isAuthRoute = currentRoute == "/auth";
      final isProfileSetupRoute = currentRoute == "/profile-setup";

      // if (kIsWeb) {
      //   return null;
      // }

      if (currentRoute == "/forgot-password" ||
          currentRoute == "/reset-password") {
        return null;
      }

      if (!isAuthenticated) {
        if (ref.read(clientNavigationProvider) != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(clientNavigationProvider.notifier).state = 0;
          });
        }
        return isAuthRoute ? null : "/auth";
      }

      if (currentRoute == '/map') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(clientNavigationProvider.notifier).state = 2;
        });
        return '/';
      }

      final currentUserRole = await ref
          .read(authControllerProvider.notifier)
          .getCurrentUserRole();

      if (currentUserRole == UserType.worker) {
        final isProfileCompleted = await ref
            .read(authControllerProvider.notifier)
            .isWorkerProfileCompleted();
        print("🎯🎯🎯Worker profile completed: $isProfileCompleted");
        final isCompleteProfileRoute =
            currentRoute == "/complete_worker_profile";

        if (!isProfileCompleted) {
          if (!isCompleteProfileRoute) {
            return "/complete_worker_profile";
          }
        } else {
          if (isCompleteProfileRoute) {
            return "/worker";
          }
        }
        if (currentRoute == "/") return "/worker";
        return null;
      }

      if (currentUserRole == UserType.client) {
        try {
          final isProfileCompleted = await ref
              .watch(profileSetupProvider.notifier)
              .checkProfileCompleted();
          final hasCompletedOnboarding = await ref
              .watch(profileSetupProvider.notifier)
              .checkProfileCompletedForUser();

          if (!hasCompletedOnboarding) {
            return isProfileSetupRoute ? null : '/profile-setup';
          }
          if (isProfileCompleted && currentRoute == "/auth" ||
              hasCompletedOnboarding && currentRoute == "/auth") {
            return '/';
          }
          if (isProfileCompleted) {
            return null;
          }

          if (hasCompletedOnboarding && !isProfileCompleted) {
            return null;
          }

          if (hasCompletedOnboarding && isProfileCompleted) {
            return isProfileSetupRoute ? '/' : null;
          }
        } catch (_) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/',
        name: 'home_client',
        builder: (context, state) => const ClientMainScreen(),
      ),
      GoRoute(
        path: '/worker',
        name: 'home_worker',
        builder: (context, state) => HomeScreenWorker(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Lottie.asset(
              'assets/animations/loading_animation.json',
              width: 150,
              height: 150,
              repeat: true,
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile_setup',
        builder: (context, state) => const CompleteProfileScreen(),
      ),
      GoRoute(
        path: '/complete_worker_profile',
        name: 'complete_worker_profile',
        builder: (context, state) => const CompleteProfessionalProfileScreen(),
      ),
      GoRoute(
        path: '/craftsman-profile/:id',
        name: 'craftsman_profile',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text('Craftsman Profile'.i18n)),
          body: Center(
            child: Text('Craftsman ID: ${state.pathParameters['id']}'.i18n),
          ),
        ),
      ),
      GoRoute(
        path: '/create-order',
        name: 'create_order',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CreateOrderScreen(
            workerId: extra?['workerId'] as String?,
            serviceId: extra?['serviceId'] as String?,
            serviceName: extra?['serviceName'] as String?,
            estimatedPrice: (extra?['estimatedPrice'] as num?)?.toDouble(),
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/saved-addresses',
        builder: (context, state) {
          return SavedAddressesScreen();
        },
      ),
      GoRoute(
        path: '/add-address',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: '/edit-address',
        builder: (context, state) {
          final address = state.extra as AddressModel;
          return EditAddressScreen(address: address);
        },
      ),
      GoRoute(
        path: '/payment-methods',
        name: 'payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/add-payment-method',
        name: 'add-payment-method',
        builder: (context, state) => const AddPaymentMethodScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/notification-settings',
        name: 'notification-settings',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/help-support',
        name: 'help-support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/faq',
        name: 'faq',
        builder: (context, state) => const FaqScreen(),
      ),
      GoRoute(
        path: '/contact-us',
        name: 'contact-us',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/worker/account-settings',
        name: 'account-settings',
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: '/worker/categories-pricing',
        name: 'categories-pricing',
        builder: (context, state) => const CategoriesPricingScreen(),
      ),
      GoRoute(
        path: '/worker/identity-verification',
        name: 'identity-verification',
        builder: (context, state) => const IdentityVerificationScreen(),
      ),
      GoRoute(
        path: '/work/add-work',
        name: 'add-work',
        builder: (context, state) => const AddWorkScreen(),
      ),
      GoRoute(
        path: '/worker/withdraw',
        name: 'withdraw',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final availableBalance = extra?['availableBalance'] as double? ?? 0;
          return WithdrawScreen(availableBalance: availableBalance);
        },
      ),
      GoRoute(
        path: '/worker/withdrawal-history',
        name: 'withdrawal-history',
        builder: (context, state) => const WithdrawalHistoryScreen(),
      ),
      GoRoute(
        path: '/order-details/:orderId',
        name: 'order-details',
        builder: (context, state) {
          final order = state.extra as WorkerOrder?;
          return OrderDetailsScreen(order: order!);
        },
      ),
      GoRoute(
        path: '/chat/:conversationId',
        name: 'chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ChatScreen(
            conversationId: state.pathParameters['conversationId']!,
            otherUserId: extra?['userId'] ?? '',
            otherUserName: extra?['userName'] ?? '',
            otherUserAvatar: extra?['userAvatar'],
          );
        },
      ),
      GoRoute(
        path: '/worker/profile',
        name: 'worker-profile',
        builder: (context, state) => const WorkerProfileScreen(),
      ),
      GoRoute(
        path: '/review',
        name: 'review',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          // إنشاء Order من البيانات المرسلة
          final order = Order(
            id: extra?['orderId'] ?? '',
            clientId: '',
            clientName: '',
            clientAvatarUrl: null,
            workerId: extra?['workerId'] ?? '',
            workerName: extra?['workerName'] ?? '',
            workerAvatarUrl: extra?['workerAvatar'],
            serviceId: null,
            serviceTitle: extra?['serviceTitle'] ?? '',
            price: extra?['price'] ?? 0.0,
            status: OrderStatus.completed,
            paymentStatus: PaymentStatus.paid,
            requestType: OrderRequestType.scheduled,
            address: '',
            latitude: null,
            longitude: null,
            description: null,
            scheduledAt: null,
            startedAt: null,
            completedAt: null,
            paidAt: DateTime.now(),
            paymentMethod: null,
            paymentTransactionId: null,
            distance: 0.0,
            rating: 0.0,
            createdAt: DateTime.now(),
          );

          return ReviewScreen(order: order);
        },
      ),
      GoRoute(
        path: '/payment-success',
        name: 'payment-success',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          return PaymentSuccessScreen(
            transactionId: extra?['transactionId'] ?? '',
            amount: extra?['amount'] ?? 0.0,
            referenceNumber: extra?['referenceNumber'] ?? '',
            orderId: extra?['orderId'] ?? '',
            workerName: extra?['workerName'] ?? '',
            serviceTitle: extra?['serviceTitle'] ?? '',
            paidAt: extra?['paidAt'] as DateTime? ?? DateTime.now(),
          );
        },
      ),
      GoRoute(
        path: '/client/workers/:workerId',
        builder: (context, state) {
          final workerId = state.pathParameters['workerId']!;
          return WorkerProfileDetailsScreen(workerId: workerId);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),
    ],
  );
});

Future<bool> _currentWebUserIsAdmin() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return false;

  final profile = await Supabase.instance.client
      .from('profiles')
      .select('role')
      .eq('id', userId)
      .maybeSingle();

  return profile?['role']?.toString().toLowerCase() == 'admin';
}
