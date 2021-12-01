import 'package:flutter/material.dart';
import 'package:plane/funcoes/calculartamanho.dart';

// ignore: must_be_immutable
class FormularioP extends StatelessWidget {
  //Function botaoAcao;
  var controller = TextEditingController();
  FormularioP(/*this.botaoAcao,*/ this.controller);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                CalcularTamanho(largura: MediaQuery.of(context).size.width)
                    .tamanho(10),
                0,
                CalcularTamanho(largura: MediaQuery.of(context).size.width)
                    .tamanho(10),
                0),
            child: Container(
              child: TextField(
                controller: controller,
                maxLines: 3,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Escreva aqui...",
                    fillColor: Colors.white),
              ),
              width: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                  .tamanho(500),
            ),
          ),
          /*Padding(
              padding: EdgeInsets.fromLTRB(
                  CalcularTamanho(largura: MediaQuery.of(context).size.width)
                      .tamanho(100),
                  0,
                  CalcularTamanho(largura: MediaQuery.of(context).size.width)
                      .tamanho(100),
                  0),
              child: Butao(
                texto: "Enviar",
                acao: botaoAcao,
                corBotao: Colors.green,
                icone: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              )),*/
        ],
      ),
    );
  }
}
