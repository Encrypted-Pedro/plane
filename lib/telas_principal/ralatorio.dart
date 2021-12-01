import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/lista_relatorio.dart';
import 'package:plane/funcoes/calculartamanho.dart';

class Relatorio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String uid = Autenticar().usuarioLogado(context);
    CollectionReference cr =
        db.collection("pedidos").doc("enviados").collection(uid);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: CalcularTamanho(
                            largura: MediaQuery.of(context).size.width)
                        .tamanho(5)),
                child: Icon(Icons.description),
              ),
              Text("Relatório"),
            ],
          ),
        ),
        body: FutureBuilder(
            future: cr.orderBy("datahora", descending: true).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Carregando Informações...",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(20)),
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                QuerySnapshot querySnapshot = snapshot.data;
                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.error),
                          Text("Erro ao carregar dados"),
                        ],
                      )
                    ],
                  );
                } else {
                  if (querySnapshot.docs.length == 0) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.report,
                                  color: Colors.red,
                                  size: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(60)),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: Text(
                                  "Nenhum relatório disponível",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    List<DocumentSnapshot> doc = querySnapshot.docs;
                    return ListView.builder(
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot item = doc[index];
                        return ListaRelatorio(
                            item["datahora"],
                            item["quantidade"].toString(),
                            item["peso"].toString(),
                            item.id);
                      },
                    );
                  }
                }
              }
              return Container();
            }));
  }
}
