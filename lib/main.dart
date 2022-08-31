import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:territorio/services/auth_service.dart';
import 'package:territorio/services/designacao_service.dart';
import 'package:territorio/services/mapa_services.dart';
import 'package:territorio/services/user_service.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/stores/check_box_value.dart';
import 'package:territorio/stores/concluir_designacao_store.dart';
import 'package:territorio/stores/designacao_add_store.dart';
import 'package:territorio/stores/mapas_list_all_store.dart';
import 'package:territorio/stores/ranking_bairro_mais_trabalhado_store.dart';
import 'package:territorio/stores/user_add_store.dart';
import 'package:territorio/stores/user_list_all_store.dart';
import 'package:territorio/stores/user_remove_store.dart';
import 'package:territorio/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (await Permission.mediaLibrary.request().isGranted) {
    print("aceitou");
  } else {
    print("nem ligou");
  }
  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => Dio()),
      Provider(create: (context) => AuthService(context.read())),
      Provider(create: (context) => UserService(context.read())),
      Provider(create: (context) => MapaServices(context.read())),
      Provider(create: (context) => DesignacaoServices(context.read())),
      ChangeNotifierProvider(create: ((context) => CheckBoxValue())),
      ChangeNotifierProvider(
        create: (context) => UserAddStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => UserListAllStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => MapasListAllStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => UserRemoveStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => DesignacaoAddStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => ConcluirDesignacaoStore(context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => RankingBairroMaisTrabalhadoStore(context.read()),
      ),
    ],
    child: MaterialApp(
      initialRoute: "/",
      routes: {"/": (context) => LoginView()},
      theme: ThemeData(
          textTheme: const TextTheme(
              caption: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Color.fromARGB(255, 27, 96, 160)),
              headline1: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Montserrat",
              ),
              headline6: TextStyle(
                  fontSize: 36.0,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Colors.white),
              headline2: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
              ),
              headline5: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Colors.black),
              headline3: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Colors.white),
              headline4: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Colors.black26),
              bodyText1: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Color.fromARGB(255, 27, 96, 160)),
              button: TextStyle(
                  fontSize: 19.0,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Montserrat",
                  color: Colors.white)),
          primarySwatch: Colors.red,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 27, 96, 160)),
          primaryColor: const Color.fromARGB(255, 27, 96, 160),
          fontFamily: "Montserrat",
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 27, 96, 160))),
      title: "Território",
      debugShowCheckedModeBanner: false,
    ),
  ));
}
