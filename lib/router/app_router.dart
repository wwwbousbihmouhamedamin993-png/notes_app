import 'package:go_router/go_router.dart';
import 'package:notes_app/screens/login_screen.dart';
import 'package:notes_app/screens/signup_screen.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/providers/auth_provider.dart';

class Routes {
  static const loginRoute = '/login';
  static const signUpRoute = '/signUp';
  static const homeScreenRoute = '/home';
}

final routeProvider = Provider(
  (ref) {
    final user = ref.watch(authProvider);
    return GoRouter(
      initialLocation: Routes.loginRoute,
      //u can also add error page that if the user went to undefiend route u go to this page using errorBuilder:
      redirect: (context, state) {
        final isLoggedIn = user != null;
        final isOnAuth =
            state.matchedLocation == Routes.loginRoute ||
            state.matchedLocation == Routes.signUpRoute;
        if (!isLoggedIn && !isOnAuth) return Routes.loginRoute;
        if (isLoggedIn && isOnAuth) return Routes.homeScreenRoute;
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.loginRoute,
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: Routes.signUpRoute,
          builder: (context, state) => SignUpScreen(),
        ),
        GoRoute(
          path: Routes.homeScreenRoute,
          builder: (context, state) => HomeScreen(),
        ),
      ],
    );
  },
);
