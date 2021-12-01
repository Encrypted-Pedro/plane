import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/botao.dart';
import 'package:plane/form/dialogo_info.dart';
import 'package:plane/principal.dart';
import 'package:sizer/sizer.dart';

class ManutencaoBloq extends StatefulWidget {
  @override
  _ManutencaoBloqState createState() => _ManutencaoBloqState();
  final int tipo;
  ManutencaoBloq(this.tipo);
}

FirebaseFirestore db = FirebaseFirestore.instance;
int aguardar = 0;

class _ManutencaoBloqState extends State<ManutencaoBloq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.error),
            ),
            Text("Canaã Reciclagem")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.tipo == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.miscellaneous_services_outlined,
                          color: Colors.blueAccent,
                          size: 18.0.h,
                        ),
                      ),
                      Text(
                        "Estamos em manutenção, por favor aguarde!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: aguardar == 0
                            ? Botao(
                                texto: "Atualizar",
                                acao: () async {
                                  aguardar = 1;
                                  setState(() {});
                                  await db
                                      .collection("app")
                                      .doc("gerenciamento")
                                      .get()
                                      .then((value) {
                                    if (value["manutencao"] == 0) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => Principal(),
                                          ),
                                          (route) => false);
                                    } else {
                                      aguardar = 0;
                                      setState(() {});
                                      DialogoInfo(
                                        context: context,
                                        titulo: "Em manutenção",
                                        mensagem:
                                            "Ainda estamos em manutenção!",
                                      );
                                    }
                                  });
                                },
                                icone: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(
                          Icons.error_outlined,
                          color: Colors.orange,
                          size: 10.0.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Seu aplicativo está desatualizado, por favor siga os passos a seguir para obter a última versão.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "1 - Vá até o Play Store\n2 - Pequise por 'Cannã Reciclagem'\n3 - Clique no botão 'Atualizar'\n4 - Levará um tempo até o processo concluir, assim que terminado abra novamento o app.",
                          style: TextStyle(fontSize: 14.0.sp),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
