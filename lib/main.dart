import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plane/login.dart';
import 'package:plane/principal.dart';
import 'package:plane/telas_principal/pedido.dart';
import 'package:plane/telas_principal/ralatorio.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('pt_BR').then((_) =>
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((value) => runApp(MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizerUtil().init(constraints, orientation);
            return MaterialApp(
                initialRoute: "/",
                routes: {
                  "/principal": (context) => Principal(),
                  "/pedido": (context) => Pedido(),
                  "/relatorio": (context) => Relatorio(),
                  "/login": (context) => Login(),
                },
                debugShowCheckedModeBanner: false,
                title: 'Canaã Reciclagem',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: user != null ? Principal() : Login());
          },
        );
      },
    );
  }
}
