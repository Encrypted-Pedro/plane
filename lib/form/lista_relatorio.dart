import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plane/funcoes/calculartamanho.dart';
import 'package:plane/telas_principal/detalhes_relatorio.dart';

// ignore: must_be_immutable
class ListaRelatorio extends StatelessWidget {
  Timestamp data;
  String itens;
  String peso;
  String idColection;
  ListaRelatorio(this.data, this.itens, this.peso, this.idColection);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalhesRelatorio(formatarData(data), idColection),
          )),
      child: Card(
          child: Padding(
              padding: EdgeInsets.all(
                  CalcularTamanho(largura: MediaQuery.of(context).size.width)
                      .tamanho(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(5)),
                          child: Icon(Icons.description),
                        ),
                        Text(
                          formatarData(data),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Número de itens: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(itens),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Peso total: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(peso),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: Text(
                      "Toque aqui para mais detalhes",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ))),
    );
  }

  String formatarData(Timestamp data) {
    var dataC =
        DateTime.fromMillisecondsSinceEpoch(data.millisecondsSinceEpoch);
    dataC = dataC.add(Duration(hours: -3));
    String dataFormatada =
        DateFormat("dd/MM/yyyy HH:mm:ss", "pt-BR").format(dataC);
    return dataFormatada;
  }
}
