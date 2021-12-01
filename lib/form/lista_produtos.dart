import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/funcoes/calculartamanho.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class ListaProdutos extends StatefulWidget {
  int exibir = 0;
  String produto;
  String quantidade;
  String peso;
  String id;
  ListaProdutos(this.exibir, this.produto, this.quantidade, this.peso, this.id);

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int remov = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
            CalcularTamanho(largura: MediaQuery.of(context).size.width)
                .tamanho(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Produto: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                        ),
                        Text(cortarNome(widget.produto),
                            style: TextStyle(fontSize: 12.0.sp))
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Quantidade: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                        ),
                        Text(widget.quantidade,
                            style: TextStyle(fontSize: 12.0.sp)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Peso total: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                    ),
                    Text(widget.peso, style: TextStyle(fontSize: 12.0.sp)),
                  ],
                ),
              ],
            ),
            widget.exibir == 0
                ? GestureDetector(
                    onTap: () {
                      if (remov == 0) {
                        alterarCondicao(1);
                        removerItem(widget.id);
                      }
                    },
                    child: remov == 1
                        ? CircularProgressIndicator()
                        : Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.red,
                          ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  alterarCondicao(int rem) {
    setState(() {
      remov = rem;
    });
  }

  removerItem(String id) async {
    try {
      String uid = Autenticar().usuarioLogado(context);
      await db
          .collection("pedidos")
          .doc("em-andamento")
          .collection(uid)
          .doc(id)
          .delete()
          .then((value) {
        alterarCondicao(0);
      });
    } catch (e) {
      //Passa
    }
  }

  String cortarNome(String produto) {
    String corte = produto;
    if (widget.exibir == 0) {
      if (corte.length > 35) {
        corte = corte.substring(0, 33);
        corte = corte + "...";
      }
    } else {
      if (corte.length > 40) {
        corte = corte.substring(0, 37);
        corte = corte + "...";
      }
    }
    print(corte.length);
    return corte;
  }
}
