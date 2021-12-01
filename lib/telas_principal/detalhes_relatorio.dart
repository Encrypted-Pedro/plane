import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/lista_produtos.dart';
import 'package:plane/funcoes/calculartamanho.dart';

// ignore: must_be_immutable
class DetalhesRelatorio extends StatelessWidget {
  String data;
  String idDoc;
  DetalhesRelatorio(this.data, this.idDoc);
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String uid = Autenticar().usuarioLogado(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: CalcularTamanho(
                            largura: MediaQuery.of(context).size.width)
                        .tamanho(5)),
                child: Icon(Icons.assessment),
              ),
              Text(data),
            ],
          ),
        ),
        body: FutureBuilder(
            future: db
                .collection("pedidos")
                .doc("enviados")
                .collection(uid)
                .doc(idDoc)
                .collection("produtos")
                .get(),
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
                              Icon(Icons.remove_shopping_cart,
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
                                  "Não existem produtos nesta lista",
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
                      itemCount: doc.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot item = doc[index];
                        return ListaProdutos(
                            1,
                            item["produto"],
                            item["quantidade"].toString(),
                            item["peso"].toString(),
                            "x");
                      },
                    );
                  }
                }
              }
              return Container();
            }));
  }
}
