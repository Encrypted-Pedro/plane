import 'package:flutter/material.dart';
import 'botao.dart';

class DialogoInfo {
  DialogoInfo(
      {@required BuildContext context,
      int navFecha = 0,
      @required String titulo,
      @required String mensagem,
      Color corBotao = Colors.green,
      String textoBotao = "Fechar",
      String rota = "",
      Icon icone,
      String rotaSaida}) {
    showDialog(
      context: context,
      barrierDismissible: rotaSaida != null ? false : true,
      builder: (context) => AlertDialog(
        actions: [
          Container(
            child: Botao(
              corBotao: corBotao,
              texto: textoBotao,
              acao: () {
                rotaSaida != null
                    ? Navigator.pushNamedAndRemoveUntil(
                        context, rotaSaida, (bool) => false)
                    : Navigator.pop(context);
              },
              tamanhoFonte: 10,
              icone: Icon(
                Icons.close,
                color: Colors.white,
                size: 12,
              ),
            ),
            width: 80,
            height: 30,
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          titulo,
          textAlign: TextAlign.center,
        ),
        content: icone != null
            ? icone
            : Text(
                mensagem,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
