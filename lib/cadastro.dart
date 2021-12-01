import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/botao.dart';
import 'package:plane/form/campo_texto.dart';
import 'package:plane/form/carrega_logo_termos.dart';
import 'package:plane/form/dialogo_info.dart';
import 'package:plane/form/validar_cadastro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'form/validar_msgerro.dart';
import 'funcoes/calculartamanho.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class Cadastro extends StatefulWidget {
  String userCustom = "";
  int edicao = 0;
  String senhaAnterior;
  Cadastro(
      {String nome,
      String rg,
      String cpf,
      String datanasc,
      String logradouro,
      String bairro,
      String numero,
      String cep,
      String cidade,
      String estado,
      String celular,
      String email,
      String usuario,
      String senha}) {
    if (usuario != null) {
      userCustom = usuario;
      edicao = 1;
      senhaAnterior = senha;
      alterarSenha = 0;
      print(usuario);
    } else {
      alterarSenha = 1;
    }
    this.nome.text = nome;
    this.rg.text = rg;
    this.cpf.text = cpf;
    this.datanasc.text = datanasc;
    this.logradouro.text = logradouro;
    this.bairro.text = bairro;
    this.numero.text = numero;
    this.cep.text = cep;
    this.cidade.text = cidade;
    this.estado.text = estado;
    this.celular.text = celular;
    this.email.text = email;
    this.usuario.text = usuario;
  }

  @override
  _CadastroState createState() => _CadastroState();
  var nome = TextEditingController();

  var rg = TextEditingController();

  var cpf = TextEditingController();

  var datanasc = TextEditingController();

  var logradouro = TextEditingController();

  var bairro = TextEditingController();

  var numero = TextEditingController();

  var cep = TextEditingController();

  var cidade = TextEditingController();

  var estado = TextEditingController();

  var celular = TextEditingController();

  var email = TextEditingController();

  var usuario = TextEditingController();

  var senha = TextEditingController();
  var confsenha = TextEditingController();

  bool erroNome = false;
  bool erroRg = false;
  bool erroCpf = false;
  bool erroNasc = false;

  bool erroLogradoro = false;
  bool erroBairro = false;
  bool erroNumero = false;
  bool erroCep = false;
  bool erroCidade = false;
  bool erroEstado = false;

  bool erroCelular = false;

  bool erroUsuario = false;
  bool erroSenha = false;
  bool erroConfSenha = false;

  bool existeCpf = false;
  bool existeUsuario = false;
  bool cpfErro = false;
  bool usuarioErro = false;
  bool erroEmail = false;

  bool confereSenha = false;
  bool bloqSenha = false;
  bool senhasiguais = false;
}

int alterarSenha = 1;

class _CadastroState extends State<Cadastro> {
  int enviando = 0;
  int aguarde = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: widget.userCustom != ""
            ? Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(5)),
                    child: Icon(Icons.create),
                  ),
                  Text("Canaã Reciclagem - Editar cadastro",
                      style: TextStyle(fontSize: 12.0.sp)),
                ],
              )
            : Text("Canaã Reciclagem - Cadastro",
                style: TextStyle(fontSize: 12.0.sp)),
        leading: widget.userCustom != "" ? null : Icon(Icons.create),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.userCustom == ""
                ? Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: Icon(Icons.person),
                              ),
                              Text(
                                "Dados pessoais",
                                style: TextStyle(
                                    fontSize: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(20)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10)),
                          child: CaixaTexo(
                            hint: "Nome",
                            icone: Icon(Icons.person),
                            controle: widget.nome,
                            habilitar: widget.edicao == 0 ? true : false,
                            temErro: widget.erroNome,
                          ),
                        ),
                        widget.erroNome != false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: MensagemValidar(
                                  texto:
                                      "Campo vazio ou menor que 4 caracteres",
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              left: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: CaixaTexo(
                            hint: "RG",
                            icone: Icon(Icons.person),
                            controle: widget.rg,
                            habilitar: widget.edicao == 0 ? true : false,
                            temErro: widget.erroRg,
                          ),
                        ),
                        widget.erroRg != false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: MensagemValidar(
                                  texto:
                                      "Campo vazio ou menor que 4 caracteres",
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              left: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: CaixaTexo(
                            hint: "CPF",
                            icone: Icon(Icons.person),
                            cpf: 1,
                            contato: 2,
                            controle: widget.cpf,
                            habilitar: widget.edicao == 0 ? true : false,
                            temErro: widget.cpfErro,
                          ),
                        ),
                        widget.erroCpf != false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: MensagemValidar(
                                  texto: "Campo preenchido incorretamente",
                                ),
                              )
                            : widget.existeCpf != false
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(10)),
                                    child: MensagemValidar(
                                      texto: "Este CPF já está cadastrado",
                                    ),
                                  )
                                : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              left: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: CaixaTexo(
                            hint: "Data de nascimento",
                            icone: Icon(Icons.person),
                            datNasc: 1,
                            contato: 2,
                            controle: widget.datanasc,
                            habilitar: widget.edicao == 0 ? true : false,
                            temErro: widget.erroNasc,
                          ),
                        ),
                        widget.erroNasc != false
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: CalcularTamanho(
                                            largura: MediaQuery.of(context)
                                                .size
                                                .width)
                                        .tamanho(10)),
                                child: MensagemValidar(
                                  texto: "Campo preenchido incorretamente",
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                : Container(),
            Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: Icon(Icons.map),
                        ),
                        Text(
                          "Endereço",
                          style: TextStyle(
                              fontSize: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(20)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10),
                    ),
                    child: CaixaTexo(
                      hint: "Logradouro (Ex.: Rua Maria)",
                      icone: Icon(Icons.pin_drop),
                      controle: widget.logradouro,
                      temErro: widget.erroLogradoro,
                    ),
                  ),
                  widget.erroLogradoro != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio ou menor que 4 caracteres",
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: CaixaTexo(
                      hint: "Bairro",
                      icone: Icon(Icons.pin_drop),
                      controle: widget.bairro,
                      temErro: widget.erroBairro,
                    ),
                  ),
                  widget.erroBairro != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio",
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: CaixaTexo(
                      hint: "Número",
                      contato: 2,
                      numero: 1,
                      icone: Icon(Icons.pin_drop),
                      controle: widget.numero,
                      temErro: widget.erroNumero,
                    ),
                  ),
                  widget.erroNumero != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio",
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: CaixaTexo(
                      hint: "CEP",
                      icone: Icon(Icons.pin_drop),
                      cep: 1,
                      contato: 2,
                      controle: widget.cep,
                      temErro: widget.erroCep,
                    ),
                  ),
                  widget.erroCep != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo preenchido incorretamente",
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: CaixaTexo(
                      hint: "Cidade",
                      icone: Icon(Icons.pin_drop),
                      controle: widget.cidade,
                      temErro: widget.erroCidade,
                    ),
                  ),
                  widget.erroCidade != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio ou menor que 4 caracteres",
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        right: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: CaixaTexo(
                      hint: "Estado",
                      icone: Icon(Icons.pin_drop),
                      controle: widget.estado,
                      temErro: widget.erroEstado,
                    ),
                  ),
                  widget.erroEstado != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio ou menor que 2 caracteres",
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        bottom: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: Icon(Icons.contact_phone),
                        ),
                        Text(
                          "Contato",
                          style: TextStyle(
                              fontSize: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(20)),
                        ),
                      ],
                    ),
                  ),
                  widget.userCustom == ""
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              left: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10),
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: CaixaTexo(
                            hint: "Apelido",
                            icone: Icon(Icons.person_outline),
                            controle: widget.usuario,
                            habilitar: widget.edicao == 0 ? true : false,
                            temErro: widget.usuarioErro,
                          ),
                        )
                      : Container(),
                  widget.erroUsuario != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo vazio ou menor que 4 caracteres",
                          ),
                        )
                      : widget.existeUsuario != false
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                              child: MensagemValidar(
                                texto: "Este Apelido já está cadastrado.",
                              ),
                            )
                          : Container(),
                  Padding(
                    padding: EdgeInsets.all(
                      CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10),
                    ),
                    child: CaixaTexo(
                        hint: "Nº de Celular",
                        icone: Icon(Icons.phone),
                        contato: 1,
                        controle: widget.celular,
                        temErro: widget.erroCelular),
                  ),
                  widget.erroCelular != false
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                          child: MensagemValidar(
                            texto: "Campo preenchido incorretamente",
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Card(
              elevation: 10,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10),
                      bottom: CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10)),
                        child: Icon(Icons.exit_to_app),
                      ),
                      Text(
                        "Dados para conexão",
                        style: TextStyle(
                            fontSize: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(20)),
                      ),
                    ],
                  ),
                ),
                widget.userCustom == ""
                    ? Padding(
                        padding: EdgeInsets.all(
                          CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                        ),
                        child: CaixaTexo(
                          hint: "E-Mail",
                          icone: Icon(Icons.email),
                          controle: widget.email,
                          temErro: widget.erroEmail,
                        ),
                      )
                    : Container(),
                widget.erroEmail != false
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10)),
                        child: MensagemValidar(
                          texto: "Dados incorretos",
                        ),
                      )
                    : Container(),
                alterarSenha == 0
                    ? Padding(
                        padding: EdgeInsets.all(CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(20)),
                        child: Botao(
                          texto: "Alterar senha",
                          acao: () {
                            setState(() {
                              alterarSenha = 1;
                            });
                          },
                          corBotao: Colors.blue,
                          icone: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
                alterarSenha == 1
                    ? Padding(
                        padding: widget.userCustom == ""
                            ? EdgeInsets.only(
                                bottom: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                left: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                right: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                                    .tamanho(10))
                            : EdgeInsets.only(
                                bottom: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                left: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                right: CalcularTamanho(
                                        largura: MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                top: CalcularTamanho(largura: MediaQuery.of(context).size.width).tamanho(10)),
                        child: CaixaTexo(
                          hint:
                              widget.userCustom != "" ? "Senha atual" : "Senha",
                          icone: Icon(Icons.vpn_key),
                          controle: widget.senha,
                          temErro: widget.erroSenha,
                          ocultarTexto: true,
                        ),
                      )
                    : Container(),
                widget.erroSenha != false
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10)),
                        child: MensagemValidar(
                          texto: "Campo vazio ou menor que 6 caracteres",
                        ),
                      )
                    : Container(),
                alterarSenha == 1
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10),
                            left: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10),
                            right: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10)),
                        child: CaixaTexo(
                          hint: widget.userCustom != ""
                              ? "Nova senha"
                              : "Confirmar senha",
                          icone: Icon(Icons.vpn_key),
                          controle: widget.confsenha,
                          temErro: widget.bloqSenha,
                          ocultarTexto: true,
                        ),
                      )
                    : Container(),
                widget.erroConfSenha != false
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(10)),
                        child: MensagemValidar(
                          texto: "Campo vazio ou menor que 6 caracteres",
                        ),
                      )
                    : widget.confereSenha != false
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(10)),
                            child: MensagemValidar(
                              texto: "As senhas estão diferentes, verifique.",
                            ),
                          )
                        : Container(),
              ]),
            ),
            aguarde == 0
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                        CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10),
                        CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: Botao(
                      texto: "Salvar Informações",
                      acao: () async {
                        setState(() {
                          aguarde = 1;
                        });
                        widget.erroNome = Validador()
                            .validarVazioTam(widget.nome.text, 4, false, false);
                        widget.erroRg = Validador()
                            .validarVazioTam(widget.rg.text, 4, false, false);
                        widget.erroCpf = Validador()
                            .validarVazioTam(widget.cpf.text, 14, true, false);
                        widget.erroNasc = Validador().validarVazioTam(
                            widget.datanasc.text, 10, false, true);
                        widget.erroLogradoro = Validador().validarVazioTam(
                            widget.logradouro.text, 4, false, false);
                        widget.erroBairro =
                            Validador().validarVazio(widget.bairro.text);
                        widget.erroNumero =
                            Validador().validarVazio(widget.numero.text);
                        widget.erroCep = Validador()
                            .validarVazioTam(widget.cep.text, 9, false, false);
                        widget.erroCidade = Validador().validarVazioTam(
                            widget.cidade.text, 4, false, false);
                        widget.erroEstado = Validador().validarVazioTam(
                            widget.estado.text, 2, false, false);
                        widget.erroCelular = Validador().validarVazioTam(
                            widget.celular.text, 15, false, false);
                        widget.erroUsuario = Validador().validarVazioTam(
                            widget.usuario.text, 4, false, false);
                        widget.erroEmail =
                            Validador().validarEmail(widget.email.text);
                        if (widget.edicao == 0 ||
                            widget.edicao == 1 && widget.senha.text != "") {
                          widget.erroSenha = Validador().validarVazioTam(
                              widget.senha.text, 6, false, false);
                          widget.erroConfSenha = Validador().validarVazioTam(
                              widget.confsenha.text, 6, false, false);
                          if (widget.userCustom != "") {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User user = auth.currentUser;
                            widget.email.text = user.email;
                            widget.confereSenha = await Validador()
                                .conferirSenha(widget.confsenha.text,
                                    widget.senha.text, widget.email.text);
                          }
                        }
                        if (widget.edicao == 0) {
                          widget.existeCpf =
                              await Validador().validarCpf(widget.cpf.text);
                          widget.existeUsuario = await Validador()
                              .validarUsuario(widget.usuario.text);
                          widget.confereSenha = Validador().senhasIguais(
                              widget.senha.text, widget.confsenha.text);
                        }
                        if (widget.erroCpf == true ||
                            widget.existeCpf == true) {
                          widget.cpfErro = true;
                        }
                        if (widget.erroUsuario == true ||
                            widget.existeUsuario == true) {
                          widget.usuarioErro = true;
                        }
                        if (widget.erroConfSenha == true ||
                            widget.confereSenha == true) {
                          widget.bloqSenha = true;
                        }
                        if (widget.erroNome == false &&
                            widget.erroRg == false &&
                            widget.erroNome == false &&
                            widget.erroCpf == false &&
                            widget.erroNasc == false &&
                            widget.erroLogradoro == false &&
                            widget.erroBairro == false &&
                            widget.erroNumero == false &&
                            widget.erroCep == false &&
                            widget.erroCidade == false &&
                            widget.erroEstado == false &&
                            widget.erroCelular == false &&
                            widget.erroUsuario == false &&
                            widget.existeCpf == false &&
                            widget.existeUsuario == false &&
                            widget.erroEmail == false) {
                          if (widget.edicao == 1) {
                            if (widget.senha.text != "") {
                              if (widget.confereSenha == true) {
                                widget.confereSenha = false;
                                Autenticar().editarCadastro(
                                    widget.datanasc.text,
                                    widget.logradouro.text,
                                    widget.bairro.text,
                                    widget.numero.text,
                                    widget.cep.text,
                                    widget.cidade.text,
                                    widget.estado.text,
                                    widget.celular.text,
                                    widget.confsenha.text,
                                    context);
                              } else {
                                print("Senha incorreta");
                                aguarde = 0;
                                DialogoInfo(
                                    context: context,
                                    titulo: "Erro ao salvar",
                                    corBotao: Colors.red,
                                    mensagem:
                                        "Senha atual não confere, verifique.");
                              }
                            } else {
                              widget.erroSenha = false;
                              widget.erroConfSenha = false;
                              Autenticar().editarCadastro(
                                  widget.datanasc.text,
                                  widget.logradouro.text,
                                  widget.bairro.text,
                                  widget.numero.text,
                                  widget.cep.text,
                                  widget.cidade.text,
                                  widget.estado.text,
                                  widget.celular.text,
                                  "",
                                  context);
                            }
                          } else {
                            if (widget.erroSenha == false &&
                                widget.erroConfSenha == false &&
                                widget.confereSenha == false &&
                                widget.existeCpf == false &&
                                widget.existeUsuario == false) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return SingleChildScrollView(
                                        child: AlertDialog(
                                          title: Text("Novo cadastro"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Para concluir o cadastro é necessário aceitar os termos de uso.\nPara fazer a leitura clique em 'Termos de uso' abaixo.",
                                                textAlign: TextAlign.justify,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: CalcularTamanho(
                                                            largura:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                        .tamanho(10)),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    String termo =
                                                        await LogoTermo()
                                                            .carregaTermos();
                                                    launch(termo);
                                                  },
                                                  child: Text(
                                                    "Termos de uso",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            enviando == 0
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            right: CalcularTamanho(
                                                                    largura: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width)
                                                                .tamanho(20)),
                                                        child: Container(
                                                            width: 32.0.w,
                                                            child: Botao(
                                                              texto: "Sim",
                                                              acao: () {
                                                                setState(() {
                                                                  enviando = 1;
                                                                });
                                                                Autenticar().cadastrar(
                                                                    widget.nome
                                                                        .text,
                                                                    widget.rg
                                                                        .text,
                                                                    widget.cpf
                                                                        .text,
                                                                    widget
                                                                        .datanasc
                                                                        .text,
                                                                    widget
                                                                        .logradouro
                                                                        .text,
                                                                    widget
                                                                        .bairro
                                                                        .text,
                                                                    widget
                                                                        .numero
                                                                        .text,
                                                                    widget.cep
                                                                        .text,
                                                                    widget
                                                                        .cidade
                                                                        .text,
                                                                    widget
                                                                        .estado
                                                                        .text,
                                                                    widget
                                                                        .celular
                                                                        .text,
                                                                    widget
                                                                        .usuario
                                                                        .text,
                                                                    widget.email
                                                                        .text,
                                                                    widget.senha
                                                                        .text,
                                                                    context);
                                                                aguarde = 0;
                                                              },
                                                              corBotao:
                                                                  Colors.green,
                                                              tamanhoFonte: 12,
                                                              alturabotao: 30,
                                                              icone: Icon(
                                                                Icons.thumb_up,
                                                                color: Colors
                                                                    .white,
                                                                size: CalcularTamanho(
                                                                        largura: MediaQuery.of(context)
                                                                            .size
                                                                            .width)
                                                                    .tamanho(
                                                                        24),
                                                              ),
                                                            )),
                                                      ),
                                                      Container(
                                                          width: 32.0.w,
                                                          child: Botao(
                                                            texto: "Não",
                                                            acao: () {
                                                              aguarde = 0;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            corBotao:
                                                                Colors.red,
                                                            tamanhoFonte: 12,
                                                            alturabotao: 30,
                                                            icone: Icon(
                                                              Icons.thumb_down,
                                                              color:
                                                                  Colors.white,
                                                              size: CalcularTamanho(
                                                                      largura: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width)
                                                                  .tamanho(24),
                                                            ),
                                                          )),
                                                    ],
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        right: CalcularTamanho(
                                                                largura:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width)
                                                            .tamanho(120)),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              aguarde = 0;
                            }
                          }
                        } else {
                          aguarde = 0;
                          DialogoInfo(
                              context: context,
                              titulo: "Não foi possível salvar",
                              corBotao: Colors.red,
                              mensagem: "Existem campos com erro, verifique!");
                        }
                        setState(() {});
                      },
                      icone: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ))
                : CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                  ),
          ],
        ),
      ),
    );
  }
}
