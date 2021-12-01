import 'package:flutter/material.dart';

class CalcularTamanho {
  double largura;
  CalcularTamanho({@required this.largura});

  double tamanho(double entrada) {
    double tamanhoFonte;
    tamanhoFonte = 411.43 / entrada;
    tamanhoFonte = largura / tamanhoFonte;
    return tamanhoFonte;
  }
}
