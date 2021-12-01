import 'package:cloud_firestore/cloud_firestore.dart';

class LogoTermo {
  FirebaseFirestore db = FirebaseFirestore.instance;

  carregaLogo() async {
    String logo;
    await db
        .collection("arquivos")
        .doc("aplicativo")
        .get()
        .then((value) => logo = value["logo"]);
    return logo;
  }

  carregaTermos() async {
    String termos;
    await db
        .collection("arquivos")
        .doc("aplicativo")
        .get()
        .then((value) => termos = value["termos"]);
    return termos;
  }
}
