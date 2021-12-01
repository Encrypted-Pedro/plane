import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plane/cadastro.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/botao.dart';
import 'package:plane/form/carrega_logo_termos.dart';
import 'package:sizer/sizer.dart';

import 'funcoes/calculartamanho.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String nome = "";
  String rg = "";
  String cpf = "";
  String nasc = "";

  String logradouro = "";
  String bairro = "";
  String numero = "";
  String cep = "";
  String cidade = "";
  String estado = "";

  String cel = "";
  String email = "";

  String usuario = "";
  String senha = "";
  String ultimoped = "Sem pedidos";
  String logo = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    carregarDados();
    uid = Autenticar().usuarioLogado(context);
  }

  carregarLogo() async {
    logo = await LogoTermo().carregaLogo();
  }

  String uid;
  int liberado = 0;
  carregarDados() async {
    DocumentSnapshot user = await db.collection("usuarios").doc(uid).get();
    if (user.exists) {
      user.data().forEach((key, value) {
        if (key == "nome") {
          nome = value;
        } else if (key == "rg") {
          rg = value;
        } else if (key == "cpf") {
          cpf = value;
        } else if (key == "datanasc") {
          nasc = value;
        } else if (key == "endereco") {
          logradouro = value;
        } else if (key == "bairro") {
          bairro = value;
        } else if (key == "numero") {
          numero = value;
        } else if (key == "cep") {
          cep = value;
        } else if (key == "cidade") {
          cidade = value;
        } else if (key == "estado") {
          estado = value;
        } else if (key == "celular") {
          cel = value;
        } else if (key == "email") {
          email = value;
        } else if (key == "apelido") {
          usuario = value;
        } else if (key == "ultimopedido") {
          ultimoped = formatarData(value);
        }
      });
    }
  }

  String formatarData(Timestamp data) {
    var dataC =
        DateTime.fromMillisecondsSinceEpoch(data.millisecondsSinceEpoch);
    dataC = dataC.add(Duration(hours: -3));
    String dataFormatada =
        DateFormat("dd/MM/yyyy HH:mm:ss", "pt-BR").format(dataC);
    return dataFormatada;
  }

  acessoLiberado() async {
    DocumentSnapshot doc = await db.collection("usuarios").doc(uid).get();
    doc.data().forEach((key, value) {
      if (key == "libarado") {
        liberado = value;
      }
    });
  }

  deslogar(BuildContext contextync) async {
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, "/login", (bool) => false));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: acessoLiberado(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Carregando Informações...",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(20)),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return liberado == 1
              ? Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: Colors.black,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(5)),
                          child: Icon(Icons.account_circle),
                        ),
                        Text(
                          "Canaã Reciclagem - Principal",
                          style: TextStyle(fontSize: 14.0.sp),
                        ),
                      ],
                    ),
                  ),
                  body: FutureBuilder(
                    future: carregarDados(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Carregando Informações...",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(20)),
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(CalcularTamanho(
                                      largura:
                                          MediaQuery.of(context).size.width)
                                  .tamanho(10)),
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: EdgeInsets.all(CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                                  child: Container(
                                      child: Row(
                                    children: [
                                      CircleAvatar(
                                        maxRadius: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(40),
                                        child: Icon(
                                          Icons.person,
                                          size: CalcularTamanho(
                                                  largura:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width)
                                              .tamanho(60),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: CalcularTamanho(
                                                    largura:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width)
                                                .tamanho(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cortarNome(nome),
                                              style:
                                                  TextStyle(fontSize: 12.0.sp),
                                            ),
                                            Divider(
                                              height: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(5),
                                            ),
                                            Text(
                                              logradouro +
                                                  ", " +
                                                  numero +
                                                  ", " +
                                                  bairro,
                                              style:
                                                  TextStyle(fontSize: 11.0.sp),
                                            ),
                                            Divider(
                                              height: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(5),
                                            ),
                                            Text(
                                              cel,
                                              style:
                                                  TextStyle(fontSize: 11.0.sp),
                                            ),
                                            Divider(
                                              height: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(5),
                                            ),
                                            Text(
                                              "Último pedido: " + ultimoped,
                                              style:
                                                  TextStyle(fontSize: 11.0.sp),
                                            ),
                                            Divider(
                                              height: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(5),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10),
                                  bottom: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.pushNamed(context, "/pedido"),
                                    child: Container(
                                        width: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(120),
                                        height: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(100),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(10)),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.shopping_cart,
                                                color: Colors.green,
                                                size: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(50),
                                              ),
                                              Divider(
                                                height: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                              ),
                                              Text(
                                                "Fazer Pedido",
                                                style: TextStyle(
                                                    fontSize: CalcularTamanho(
                                                            largura:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                        .tamanho(15)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, "/relatorio"),
                                    child: Container(
                                        width: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(120),
                                        height: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(100),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(10)),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.description,
                                                color: Colors.orange,
                                                size: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(50),
                                              ),
                                              Divider(
                                                height: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                              ),
                                              Text(
                                                "Relatório",
                                                style: TextStyle(
                                                    fontSize: CalcularTamanho(
                                                            largura:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                        .tamanho(15)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10),
                                  bottom: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Cadastro(
                                            bairro: bairro,
                                            celular: cel,
                                            cep: cep,
                                            cidade: cidade,
                                            cpf: cpf,
                                            datanasc: nasc,
                                            email: email,
                                            estado: estado,
                                            logradouro: logradouro,
                                            nome: nome,
                                            numero: numero,
                                            rg: rg,
                                            senha: senha,
                                            usuario: usuario,
                                          ),
                                        )),
                                    child: Container(
                                        width: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(120),
                                        height: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(100),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(10)),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.account_box,
                                                color: Colors.purple,
                                                size: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(50),
                                              ),
                                              Divider(
                                                height: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                              ),
                                              Text(
                                                "Alterar Dados",
                                                style: TextStyle(
                                                    fontSize: CalcularTamanho(
                                                            largura:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                        .tamanho(15)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.0)), //this right here
                                          child: SingleChildScrollView(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        CalcularTamanho(
                                                                largura:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width)
                                                            .tamanho(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .power_settings_new,
                                                          color: Colors.red,
                                                          size: CalcularTamanho(
                                                                  largura: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width)
                                                              .tamanho(32),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: CalcularTamanho(
                                                                      largura: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width)
                                                                  .tamanho(5)),
                                                          child: Text(
                                                            "Deseja sair desta conta?",
                                                            style: TextStyle(
                                                                fontSize: CalcularTamanho(
                                                                        largura: MediaQuery.of(context)
                                                                            .size
                                                                            .width)
                                                                    .tamanho(
                                                                        18)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        CalcularTamanho(
                                                                largura:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width)
                                                            .tamanho(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                            width: 32.0.w,
                                                            child: Botao(
                                                              texto: "Sim",
                                                              acao: () {
                                                                deslogar(
                                                                    context);
                                                              },
                                                              corBotao:
                                                                  Colors.red,
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
                                                        Container(
                                                            width: 32.0.w,
                                                            child: Botao(
                                                              texto: "Não",
                                                              acao: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              corBotao:
                                                                  Colors.green,
                                                              tamanhoFonte: 12,
                                                              alturabotao: 30,
                                                              icone: Icon(
                                                                Icons
                                                                    .thumb_down,
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
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                        width: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(120),
                                        height: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(100),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(10)),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.power_settings_new,
                                                color: Colors.red,
                                                size: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(50),
                                              ),
                                              Divider(
                                                height: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                              ),
                                              Text(
                                                "Desconectar",
                                                style: TextStyle(
                                                    fontSize: CalcularTamanho(
                                                            largura:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width)
                                                        .tamanho(15)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: carregarLogo(),
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
                                    height: 25.0.h,
                                    width: 30.0.w,
                                    child: Image.network(logo),
                                  );
                                }
                                return Container();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(5)),
                              child: Text(
                                "Canaã Reciclagem",
                                style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    leading: Icon(Icons.person),
                    title: Text("Aguardando liberação"),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.block,
                            color: Colors.blue,
                            size: CalcularTamanho(
                                    largura: MediaQuery.of(context).size.width)
                                .tamanho(60),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: CalcularTamanho(
                                          largura:
                                              MediaQuery.of(context).size.width)
                                      .tamanho(10)),
                              child: Text(
                                "Seu usuário ainda não foi liberado, por favor aguarde!",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                left: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(30),
                                right: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(30)),
                            child: Botao(
                                texto: "Verificar novamente",
                                corBotao: Colors.green,
                                icone: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                acao: () {
                                  setState(() {});
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(10),
                                left: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(30),
                                right: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(30)),
                            child: Botao(
                                texto: "Sair da conta",
                                corBotao: Colors.red,
                                icone: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                acao: () {
                                  deslogar(context);
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                );
        }
        return Container();
      },
    );
  }

  String cortarNome(String produto) {
    String corte = produto;
    if (corte.length > 33) {
      corte = corte.substring(0, 31);
      corte = corte + "...";
    }
    print(corte.length);
    return corte;
  }
}
