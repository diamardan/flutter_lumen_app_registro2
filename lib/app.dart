import 'package:lumen_app_registro/ui/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumen_app_registro/src/provider/supscritions_provider.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/routes/routes.dart';
import 'package:lumen_app_registro/ui/screens/login/wrapper_auth.dart';
import 'package:lumen_app_registro/src/data/AuthenticationService.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:lumen_app_registro/src/bloc/deep_link_bloc.dart';
import 'package:provider/provider.dart';

import 'ui/res/design_constants.dart';

class MyApp extends StatelessWidget {
  // DeepLinkBloc _bloc = DeepLinkBloc();
  final ThemeData theme = ThemeData();
  @override
  Widget build(BuildContext context) {
/*DeepLinkBloc _bloc = DeepLinkBloc();
    return Provider<DeepLinkBloc>(
                create: (context) => _bloc,
                dispose: (context, bloc) => bloc.dispose(),
                child:*/

    return MultiProvider(
        providers: [
          Provider(
            create: (context) => SubscriptionsProvider(),
          ),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          StreamProvider<User>(
            create: (_) => AuthenticationService().userState,
            initialData: null,
            //  updateShouldNotify: (u1, u2) => true,
          ),
        ],
        child: MaterialApp(
            title: 'LUMEN APP REGISTRO',
            debugShowCheckedModeBanner: false,
            routes: getApplicationRoutes(context),
            theme: ThemeData(
              primaryColor: AppColors.primary,
              fontFamily: "montserrat",
              textTheme: TextTheme(
                  headline2: TextStyle(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                  bodyText1: TextStyle(
                      fontSize: AppSizes.text3Size,
                      color: AppColors.onBackground2)),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.morenaLightColor, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                /*
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 10.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),*/
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                elevation: 1,
                primary: AppColors.primary,
                minimumSize: Size(1, 45),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    //side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(30)),
              )),

              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
                titleTextStyle:
                    //   GoogleFonts.bungee(fontSize: 18, letterSpacing: 1.2),
                    GoogleFonts.francoisOne(fontSize: 18),
              ),
              scaffoldBackgroundColor: AppColors.background,
              //  buttonTheme: ButtonTheme(textTheme:TextTheme ,)
            ),
            /* initialRoute: 'wrapper', */
            home: Wrapper()));
  }
}
