import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';

import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';

import 'package:permission_handler/permission_handler.dart';

// Added imports for CallKit
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:uuid/uuid.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:async'; // For StreamSubscription

Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.locationAlways.request();
  await Permission.ignoreBatteryOptimizations.request();
}

// Global Navigator Key as requested
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // await authManager.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  // StreamSubscription for CallKit events
  StreamSubscription? _callKitSubscription;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<DipakshiriderAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    // Pass the global navigatorKey to GoRouter
    _router = createRouter(_appStateNotifier, navigatorKey);
    userStream = dipakshiriderAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    // CallKit Listener Implementation
    _callKitSubscription = FlutterCallkitIncoming.onEvent.listen((event) {
      if (event == null) return;
      switch (event.event) {
        case Event.actionCallAccept:
          print('DEBUG: Call Accepted');
          final orderId = event.body['id'] as String?;
          if (orderId != null) {
            // Navigate using the global navigator key
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => OrderDetailsPage(orderId: orderId),
              ),
            );
          }
          break;
        case Event.actionCallDecline:
          print('DEBUG: Call Declined');
          // Optional: Show snackbar if context is available (tricky from background/top-level)
          // Using a small delay to ensure context might be ready if app was just opened
          Future.delayed(Duration(milliseconds: 500), () {
            if (navigatorKey.currentContext != null) {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(content: Text("Order Declined")),
              );
            }
          });
          break;
        case Event.actionCallEnded:
          print('DEBUG: Call Ended');
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _callKitSubscription?.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'dipakshirider',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  actions.showIncomingCall(
                    "Burger King #402",
                    "Delivery - 2.5km",
                    "https://www.google.com/search?q=https://cdn-icons-png.flaticon.com/512/2922/2922506.png",
                    null, // Background URL
                  );
                },
                child: Icon(Icons.call),
                tooltip: 'Simulate Incoming Order',
              ),
            ),
          ],
        );
      },
    );
  }
}

// Dummy Target Page
class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Order ID:", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(orderId,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
