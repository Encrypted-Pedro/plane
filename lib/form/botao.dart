import 'package:flutter/material.dart';
import 'package:plane/funcoes/calculartamanho.dart';

// ignore: must_be_immutable
class Botao extends StatelessWidget {
  String texto;
  double tamanhoFonte;
  Color corBotao;
  Icon icone;
  Color fonte;
  Function acao;
  double alturabotao;

  Botao({
    @required this.texto,
    @required this.acao,
    this.tamanhoFonte = 20,
    this.corBotao = Colors.deepOrange,
    this.fonte = Colors.white,
    this.alturabotao = 50,
    this.icone = const Icon(
      Icons.input,
      color: Colors.white,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: CalcularTamanho(largura: MediaQuery.of(context).size.width)
            .tamanho(alturabotao),
        child: SizedBox(
          width: double.infinity,
          // ignore: deprecated_member_use
          child: RaisedButton(
            onPressed: acao,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10),
                      0),
                  child: icone,
                ),
                Text(
                  texto,
                  style: TextStyle(
                    fontSize: tamanhoFonte,
                    color: fonte,
                  ),
                ),
              ],
            ),
            color: corBotao,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20)),
          ),
        ));
  }
}
