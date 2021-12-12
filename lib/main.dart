import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papswap/Screens/auth/login_screen.dart';
import 'package:papswap/screens/tabs/tabs_screen.dart';
import 'package:papswap/services/authservice/authservice.dart';
import 'package:papswap/services/authservice/googlesigninprovider.dart';
import 'package:papswap/services/datarepo/postData.dart';
import 'package:papswap/services/datarepo/userData.dart';
import 'package:papswap/services/datastream/userdatastream.dart';
import 'package:papswap/widgets/global/custom_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'models/userdata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider<UserDataProvider>(
          create: (context) => UserDataProvider(),
        ),
        ChangeNotifierProvider<PostDataListProvider>(
          create: (context) => PostDataListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PapSwap',
        theme: ThemeData(
          primaryColorLight: const Color(0xffF7F7F7),
          fontFamily: 'Poppins',
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.indigo.shade900,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: StreamBuilder(
          stream: AuthService().userStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomProgressIndicator();
              }
              return StreamProvider<UserData>.value(
                value: Userdatastream().userdata(),
                initialData: Userdatastream().initialuserdata,
                child: const TabsScreen(),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
