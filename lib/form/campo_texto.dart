import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plane/funcoes/calculartamanho.dart';

// ignore: must_be_immutable
class CaixaTexo extends StatefulWidget {
  final String hint;
  final Icon icone;
  final bool ocultarTexto;
  final bool temErro;
  final int contato;
  final int email;
  final int cpf;
  final int cep;
  final int datNasc;
  final bool habilitar;
  final int numero;
  int ver = 0;
  bool ocultar = false;
  var contatof = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var cpfof = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var cepof = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  var datNascof = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var numeroof = new MaskTextInputFormatter(
      mask: '#######', filter: {"#": RegExp(r'[0-9]')});
  var controle = TextEditingController();
  CaixaTexo({
    @required this.hint,
    this.icone,
    this.ocultarTexto = false,
    this.controle,
    this.temErro = false,
    this.contato = 0,
    this.email = 0,
    this.cep = 0,
    this.datNasc = 0,
    this.cpf = 0,
    this.numero = 0,
    this.habilitar = true,
  }) {
    if (ocultarTexto == true) {
      ocultar = true;
    }
  }

  @override
  _CaixaTexoState createState() => _CaixaTexoState();
}

class _CaixaTexoState extends State<CaixaTexo> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.habilitar,
      inputFormatters: widget.contato == 1
          ? [widget.contatof]
          : widget.cep == 1
              ? [widget.cepof]
              : widget.cpf == 1
                  ? [widget.cpfof]
                  : widget.datNasc == 1
                      ? [widget.datNascof]
                      : widget.numero == 1
                          ? [widget.numeroof]
                          : [],
      controller: widget.controle,
      keyboardType: widget.contato >= 1
          ? TextInputType.number
          : widget.email == 1
              ? TextInputType.emailAddress
              : TextInputType.text,
      onChanged: (_) {
        print(widget.controle.text);
      },
      cursorColor: Colors.grey,
      obscureText: widget.ocultar,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: widget.temErro == true ? Colors.red : Colors.grey,
              width: widget.temErro == true ? 2 : 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.fromLTRB(
              CalcularTamanho(largura: MediaQuery.of(context).size.width)
                  .tamanho(20),
              0,
              CalcularTamanho(largura: MediaQuery.of(context).size.width)
                  .tamanho(20),
              0),
          hintText: widget.hint,
          labelText: widget.hint,
          labelStyle: TextStyle(
            color: widget.temErro == true ? Colors.red : Colors.grey,
          ),
          prefixIcon: widget.icone,
          suffixIcon: widget.ocultarTexto == true
              ? IconButton(
                  icon: widget.ver == 0
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      if (widget.ver == 0) {
                        widget.ver = 1;
                        widget.ocultar = false;
                      } else {
                        widget.ver = 0;
                        widget.ocultar = true;
                      }
                    });
                  })
              : null),
    );
  }
}
