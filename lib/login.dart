import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plane/cadastro.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/campo_texto.dart';
import 'package:plane/form/carrega_logo_termos.dart';
import 'package:sizer/sizer.dart';
import 'form/botao.dart';
import 'form/dialogo_info.dart';
import 'funcoes/calculartamanho.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    carregaLogo();
  }

  carregaLogo() async {
    logo = await LogoTermo().carregaLogo();
  }

  String logo = "";
  var _usuario = TextEditingController();
  var _senha = TextEditingController();
  int aguarde = 0;
  int emailEnviado = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.0, 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: CalcularTamanho(
                          largura: MediaQuery.of(context).size.width)
                      .tamanho(10),
                  right: CalcularTamanho(
                          largura: MediaQuery.of(context).size.width)
                      .tamanho(10)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                          bottom: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                          right: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(30),
                          left: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(30)),
                      child: FutureBuilder(
                        future: carregaLogo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                                height: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(200),
                                width: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(200),
                                child: Image.network(logo));
                          }
                          return Container();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10)),
                      child: Text(
                        "Canaã Reciclagem",
                        style: TextStyle(
                            fontSize: 18.0.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(5)),
                      child: CaixaTexo(
                        hint: "E-mail",
                        icone: Icon(Icons.email),
                        controle: _usuario,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(5)),
                      child: CaixaTexo(
                        hint: "Senha",
                        icone: Icon(Icons.vpn_key),
                        ocultarTexto: true,
                        controle: _senha,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            right: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(20),
                            top: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(5)),
                        child: emailEnviado == 0
                            ? GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    emailEnviado = 2;
                                  });
                                  try {
                                    if (_usuario.text != "") {
                                      if (EmailValidator.validate(
                                          _usuario.text)) {
                                        bool errusEmail = false;
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: _usuario.text,
                                                  password: "testepass");
                                        } on FirebaseAuthException catch (e) {
                                          print(e.code);
                                          if (e.code == "user-not-found") {
                                            errusEmail = true;
                                          }
                                        }
                                        if (errusEmail == false) {
                                          FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: _usuario.text)
                                              .whenComplete(() {
                                            DialogoInfo(
                                                context: context,
                                                titulo: "Sucesso",
                                                mensagem:
                                                    "Um e-mail foi enviado com as instruções para redefinir a senha.",
                                                corBotao: Colors.green);
                                            setState(() {
                                              emailEnviado = 1;
                                            });
                                          }).catchError((erro) {
                                            print(erro.toString());
                                          });
                                        } else {
                                          setState(() {
                                            emailEnviado = 0;
                                          });
                                          DialogoInfo(
                                              context: context,
                                              titulo: "Usuário não cadastrado",
                                              mensagem:
                                                  "Este usuário não esta cadastrado.",
                                              corBotao: Colors.red);
                                        }
                                      } else {
                                        setState(() {
                                          emailEnviado = 0;
                                        });
                                        DialogoInfo(
                                            context: context,
                                            titulo: "Erro",
                                            mensagem:
                                                "O e-mail foi preenchido incorretamente, verifique.",
                                            corBotao: Colors.red);
                                      }
                                    } else {
                                      setState(() {
                                        emailEnviado = 0;
                                      });
                                      DialogoInfo(
                                          context: context,
                                          titulo: "Campo em branco",
                                          mensagem:
                                              "Por favor preencha o campo de 'E-mail' para enviarmos a redefinição da senha!",
                                          corBotao: Colors.red);
                                    }
                                  } catch (e) {
                                    print(e.code);
                                    setState(() {
                                      emailEnviado = 0;
                                    });
                                    DialogoInfo(
                                        context: context,
                                        titulo: "Erro",
                                        mensagem:
                                            "Ocorreu um erro ao tentar enviar o e-mail para recuperar a senha.",
                                        corBotao: Colors.red);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.help,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: CalcularTamanho(
                                                  largura:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width)
                                              .tamanho(5)),
                                      child: Text(
                                        "Esqueci a senha",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : emailEnviado == 2
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.purple,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Icon(
                                          Icons.email,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(5)),
                                          child: Text(
                                            "Email enviado.",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ])),
                    Padding(
                      padding: EdgeInsets.only(
                          top: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                          bottom: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                          right: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10),
                          left: CalcularTamanho(
                                  largura: MediaQuery.of(context).size.width)
                              .tamanho(10)),
                      child: aguarde == 0
                          ? Botao(
                              acao: () async {
                                if (_usuario.text != "") {
                                  if (_senha.text != "") {
                                    setState(() {
                                      aguarde = 1;
                                    });
                                    aguarde = await Autenticar().logar(
                                        _usuario.text, _senha.text, context);
                                    setState(() {});
                                  } else {
                                    DialogoInfo(
                                        context: context,
                                        titulo: "Erro de login",
                                        mensagem: "O campo senha está vazio",
                                        corBotao: Colors.red);
                                  }
                                } else {
                                  DialogoInfo(
                                      context: context,
                                      titulo: "Erro de login",
                                      mensagem: "O campo usuário está vazio",
                                      corBotao: Colors.red);
                                }
                              },
                              texto: "Entrar",
                              corBotao: Colors.green,
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.green),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cadastro(),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                              child: Icon(
                                Icons.person_add,
                                color: Colors.blue,
                                size: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(30),
                              ),
                            ),
                            Text(
                              "Criar uma conta",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
