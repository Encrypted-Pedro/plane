import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/adicionar_item.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/botao.dart';
import 'package:plane/form/dialogo_info.dart';
import 'package:plane/form/form_obs.dart';
import 'package:plane/form/lista_produtos.dart';
import 'package:plane/funcoes/calculartamanho.dart';
import 'package:sizer/sizer.dart';

class Pedido extends StatefulWidget {
  @override
  _PedidoState createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
  int enviando = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid;
  @override
  void initState() {
    super.initState();
    uid = Autenticar().usuarioLogado(context);
    collectionReference =
        db.collection("pedidos").doc("em-andamento").collection(uid);
  }

  int itens = 0;
  double qtd = 0;
  double peso = 0;
  CollectionReference collectionReference;
  var _obs = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _obs.text = "";
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AdicionarItem(),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Adicionar Item"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: CalcularTamanho(
                          largura: MediaQuery.of(context).size.width)
                      .tamanho(5)),
              child: Icon(Icons.shopping_cart),
            ),
            Text("Fazer Pedido"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              QuerySnapshot doc = await db
                  .collection("pedidos")
                  .doc("em-andamento")
                  .collection(uid)
                  .get();
              if (doc.docs.length > 0) {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => StatefulBuilder(
                          builder: (context, setstate) => SingleChildScrollView(
                            child: AlertDialog(
                              actions: [
                                enviando == 0
                                    ? Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                                right: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5)),
                                            child: Container(
                                              width: 32.0.w,
                                              height: 6.0.h,
                                              child: Botao(
                                                texto: "Confirmar",
                                                acao: () async {
                                                  QuerySnapshot docks = await db
                                                      .collection("pedidos")
                                                      .doc("em-andamento")
                                                      .collection(uid)
                                                      .get();
                                                  if (docks.docs.length > 0) {
                                                    setstate(() {
                                                      enviando = 1;
                                                    });
                                                    List<Map<String, dynamic>>
                                                        lista = [];
                                                    QuerySnapshot itensQ =
                                                        await db
                                                            .collection(
                                                                "pedidos")
                                                            .doc("em-andamento")
                                                            .collection(uid)
                                                            .get();
                                                    itensQ.docs
                                                        .forEach((element) {
                                                      DocumentSnapshot item =
                                                          element;
                                                      lista.add({
                                                        "datahora":
                                                            item["datahora"],
                                                        "id": item["id"],
                                                        "peso": item["peso"],
                                                        "produto":
                                                            item["produto"],
                                                        "quantidade":
                                                            item["quantidade"],
                                                        "element": item.id
                                                      });
                                                    });
                                                    String idDoc;
                                                    await db
                                                        .collection("pedidos")
                                                        .doc("areceber")
                                                        .collection(uid)
                                                        .add({
                                                      "datahora":
                                                          DateTime.now(),
                                                      "quantidade": itens,
                                                      "peso": peso,
                                                      "observacao": _obs.text,
                                                      //"recebido": 0,
                                                    }).then((value) =>
                                                            idDoc = value.id);
                                                    lista.forEach(
                                                        (element) async {
                                                      Map<String, dynamic>
                                                          prod = element;
                                                      await db
                                                          .collection("pedidos")
                                                          .doc("areceber")
                                                          .collection(uid)
                                                          .doc(idDoc)
                                                          .collection(
                                                              "produtos")
                                                          .add(prod);
                                                    });
                                                    await db
                                                        .collection("pedidos")
                                                        .doc("enviados")
                                                        .collection(uid)
                                                        .add({
                                                      "datahora":
                                                          DateTime.now(),
                                                      "quantidade": itens,
                                                      "peso": peso,
                                                      "observacao": _obs.text,
                                                      //"recebido": 0,
                                                    }).then((value) =>
                                                            idDoc = value.id);
                                                    lista.forEach(
                                                        (element) async {
                                                      Map<String, dynamic>
                                                          prod = element;
                                                      await db
                                                          .collection("pedidos")
                                                          .doc("enviados")
                                                          .collection(uid)
                                                          .doc(idDoc)
                                                          .collection(
                                                              "produtos")
                                                          .add(prod);
                                                    });
                                                    lista.forEach(
                                                        (element) async {
                                                      Map<String, dynamic> x =
                                                          element;
                                                      x.forEach(
                                                          (key, value) async {
                                                        if (key == "element") {
                                                          await db
                                                              .collection(
                                                                  "pedidos")
                                                              .doc(
                                                                  "em-andamento")
                                                              .collection(uid)
                                                              .doc(value)
                                                              .delete();
                                                        }
                                                      });
                                                    });
                                                    await db
                                                        .collection("usuarios")
                                                        .doc(uid)
                                                        .update({
                                                      "ultimopedido":
                                                          DateTime.now()
                                                    });
                                                    setstate(() {
                                                      enviando = 0;
                                                    });
                                                    DialogoInfo(
                                                        context: context,
                                                        titulo:
                                                            "Pedido enviado!",
                                                        mensagem: null,
                                                        rotaSaida: "/principal",
                                                        icone: Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: CalcularTamanho(
                                                                  largura: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width)
                                                              .tamanho(80),
                                                        ));
                                                  } else {
                                                    DialogoInfo(
                                                        context: context,
                                                        titulo:
                                                            "Não é possível enviar",
                                                        mensagem:
                                                            "Não existem produtos a serem enviados!",
                                                        corBotao: Colors.red);
                                                  }
                                                },
                                                corBotao: Colors.green,
                                                tamanhoFonte: 11.0.sp,
                                                icone: Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5),
                                                right: CalcularTamanho(
                                                        largura: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width)
                                                    .tamanho(5)),
                                            child: Container(
                                              width: 32.0.w,
                                              height: 6.0.h,
                                              child: Botao(
                                                tamanhoFonte: 11.0.sp,
                                                texto: "Fechar",
                                                acao: () {
                                                  Navigator.of(context).pop();
                                                },
                                                corBotao: Colors.red,
                                                icone: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.indigo,
                                            size: CalcularTamanho(
                                                    largura:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width)
                                                .tamanho(32),
                                          ),
                                          Text(
                                            enviando == 0
                                                ? "Confirmar envio dos produtos?"
                                                : "Aguarde a conclusão do envio...",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.0.sp),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(20)),
                                        child: Text(
                                          "Adicionar observação (Opcional)",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0.sp),
                                        ),
                                      ),
                                      FormularioP(_obs)
                                    ],
                                  ),
                                  enviando == 1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: CalcularTamanho(
                                                      largura:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width)
                                                  .tamanho(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ));
              } else {
                DialogoInfo(
                    context: context,
                    titulo: "Não é possível enviar",
                    mensagem: "Não existem produtos a serem enviados!",
                    corBotao: Colors.red);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: db
                  .collection("pedidos")
                  .doc("em-andamento")
                  .collection(uid)
                  .snapshots(),
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
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.docs.length == 0) {
                    itens = 0;
                    qtd = 0;
                    peso = 0;
                  } else {
                    qtd = 0;
                    peso = 0;
                    itens = 0;
                    querySnapshot.docs.forEach((element) {
                      DocumentSnapshot item = element;
                      qtd += item["quantidade"];
                      peso += (item["peso"] * item["quantidade"]);
                      peso = double.parse(peso.toStringAsFixed(2));
                      itens++;
                    });
                  }
                  return Card(
                    color: Colors.purple,
                    child: Padding(
                      padding: EdgeInsets.all(CalcularTamanho(
                              largura: MediaQuery.of(context).size.width)
                          .tamanho(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(5)),
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Número de Itens: " + itens.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(5)),
                                    child: Icon(
                                      Icons.fitness_center,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Peso total: " + peso.toString() + " kg",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: CalcularTamanho(
                                        largura:
                                            MediaQuery.of(context).size.width)
                                    .tamanho(10)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: CalcularTamanho(
                                              largura: MediaQuery.of(context)
                                                  .size
                                                  .width)
                                          .tamanho(5)),
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Quantidade de Itens: " + qtd.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }),
          Expanded(
              child: StreamBuilder(
                  stream: collectionReference
                      .orderBy("datahora", descending: true)
                      .snapshots(),
                  /*db
                      .collection("pedidos")
                      .doc("em-andamento")
                      .collection(uid)
                      .snapshots(),*/
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                        ConnectionState.active) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.error),
                                Text("Erro ao carregar dados"),
                              ],
                            )
                          ],
                        );
                      } else {
                        if (querySnapshot.docs.length == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.remove_shopping_cart,
                                      color: Colors.red,
                                      size: CalcularTamanho(
                                              largura: MediaQuery.of(context)
                                                  .size
                                                  .width)
                                          .tamanho(60)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: CalcularTamanho(
                                                largura: MediaQuery.of(context)
                                                    .size
                                                    .width)
                                            .tamanho(10)),
                                    child: Text(
                                      "Nenhum item foi adicionado",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        } else {
                          return ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              List<DocumentSnapshot> doc =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot item = doc[index];
                              return ListaProdutos(
                                  0,
                                  item["produto"],
                                  item["quantidade"].toString(),
                                  item["peso"].toString(),
                                  item.id);
                            },
                          );
                        }
                      }
                    }
                    return Container();
                  })),
        ],
      ),
    );
  }
}
