import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunfireworks/services/ApiClient.dart';
import 'package:sunfireworks/utils/media_query_helper.dart';
import 'app_routes/StateInjector.dart';
import 'app_routes/router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  ApiClient.setupInterceptors();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiProvider(
        providers: StateInjector.blocProviders,
        child: MaterialApp.router(
          builder: (BuildContext context, Widget? child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: 1.0),
              child: child ?? Container(),
            );
          },
          title: 'Sun FireWorks',
          theme: ThemeData(
            visualDensity: VisualDensity.compact,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white,
            dialogBackgroundColor: Colors.white,
            cardColor: Colors.white,
            searchBarTheme: const SearchBarThemeData(),
            tabBarTheme: const TabBarThemeData(),
            inputDecorationTheme: InputDecorationTheme(),
            dialogTheme: const DialogThemeData(
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            buttonTheme: const ButtonThemeData(),
            popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white,
              shadowColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              foregroundColor: Colors.white,
            ),
            cardTheme: CardThemeData(
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              color: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
            elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle()),
            outlinedButtonTheme: OutlinedButtonThemeData(style: ButtonStyle()),
            bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
            ),
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              background: Colors.black,
            ).copyWith(background: Colors.black),
            // Optionally, set directly as fallback
            primaryColor: Colors.black,
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              displayLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              displayMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              displaySmall: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              headlineLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              headlineMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              headlineSmall: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              titleLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              titleMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              titleSmall: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              bodySmall: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              labelLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              labelMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
              ),
              labelSmall: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
