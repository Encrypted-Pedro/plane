import 'package:flutter/material.dart';
import 'package:plane/funcoes/calculartamanho.dart';

// ignore: must_be_immutable
class MensagemValidar extends StatelessWidget {
  String texto;

  MensagemValidar({this.texto = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          CalcularTamanho(largura: MediaQuery.of(context).size.width)
              .tamanho(52),
          0,
          0,
          0),
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.info,
              color: Colors.red,
            ),
            Text(
              texto,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: CalcularTamanho(
                          largura: MediaQuery.of(context).size.width)
                      .tamanho(15)),
            )
          ],
        ),
      ),
    );
  }
}
