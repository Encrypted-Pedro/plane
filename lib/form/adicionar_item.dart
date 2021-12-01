import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:plane/form/autenticacao.dart';
import 'package:plane/form/botao.dart';
import 'package:plane/form/campo_texto.dart';
import 'package:plane/form/dialogo_info.dart';
import 'package:plane/form/validar_msgerro.dart';
import 'package:plane/funcoes/calculartamanho.dart';
import 'package:sizer/sizer.dart';

class AdicionarItem extends StatefulWidget {
  @override
  _AdicionarItemState createState() => _AdicionarItemState();
}

String selec = "";
bool erroQtd = false;
bool erroPrd = false;
final _qtdItem = TextEditingController();
final _produtocontrole = TextEditingController();
List<String> _itens = [
  /*"Água mineral indaiá 300ml (Transparente)",
  "Embalagem plastil 5kgs (Verde)",
  "Papelão de televisão samsung 55' - Ótimo estado"*/
];

class _AdicionarItemState extends State<AdicionarItem> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  preencherItens() async {
    QuerySnapshot itens = await db.collection("produtos").get();
    itens.docs.forEach((element) {
      _itens.add(element["nome"].toString());
    });
  }

  String uid;
  @override
  void initState() {
    super.initState();
    _itens.clear();
    preencherItens();
    uid = Autenticar().usuarioLogado(context);
  }

  pesoProduto(String id) async {
    double peso;
    await db
        .collection("produtos")
        .doc(id)
        .get()
        .then((value) => peso = value["peso"]);
    return peso;
  }

  enviarProduto(String produto, double quantidade) async {
    int id = await idProduto(produto);
    double peso = await pesoProduto(id.toString());
    print("ID: " + id.toString());
    await db.collection("pedidos").doc("em-andamento").collection(uid).add({
      "produto": produto,
      "quantidade": quantidade,
      "peso": peso,
      "id": id,
      "datahora": DateTime.now(),
    }).then((value) {
      setState(() {
        aguarde = 0;
      });
    });
  }

  idProduto(String nome) async {
    int id;
    await db
        .collection("produtos")
        .where("nome", isEqualTo: nome)
        .get()
        .then((value) => id = int.parse(value.docs.first.id));
    return id;
  }

  int aguarde = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.add),
          Text(
            "Adicionar um novo item",
            style: TextStyle(fontSize: 14.0.sp),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownField(
            itemsVisibleInDropdown: 2,
            hintText: "Digite o nome do item",
            hintStyle: TextStyle(fontSize: 10.0.sp),
            items: _itens,
            enabled: true,
            strict: false,
            controller: _produtocontrole,
            onValueChanged: (value) {
              selec = value;
            },
          ),
          erroPrd != false
              ? MensagemValidar(
                  texto: "Produto inválido.",
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(
                top: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                    .tamanho(10)),
            child: CaixaTexo(
              hint: "Quantidade (Ex.: 1 ou 0.5)",
              icone: Icon(Icons.add_shopping_cart),
              contato: 2,
              controle: _qtdItem,
              temErro: erroQtd,
            ),
          ),
          erroQtd != false
              ? MensagemValidar(
                  texto: "Valor inválido, verifique.",
                )
              : Container(),
        ],
      ),
      actions: [
        aguarde == 0
            ? Row(
                children: [
                  Container(
                      width: 32.0.w,
                      height: 7.0.h,
                      child: Botao(
                        tamanhoFonte: 11.0.sp,
                        texto: "Adicionar",
                        acao: () {
                          setState(() {
                            if (selec == "") {
                              erroPrd = true;
                            } else {
                              try {
                                erroPrd = false;
                                erroQtd = false;
                                double qtd = double.parse(_qtdItem.text);
                                aguarde = 1;
                                enviarProduto(selec, qtd);
                                DialogoInfo(
                                    context: context,
                                    titulo: "Adicionado com sucesso!",
                                    mensagem: null,
                                    icone: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: CalcularTamanho(
                                              largura: MediaQuery.of(context)
                                                  .size
                                                  .width)
                                          .tamanho(80),
                                    ));
                                selec = "";
                                _produtocontrole.text = "";
                                _qtdItem.text = "";
                              } catch (Exeption) {
                                erroQtd = true;
                              }
                            }
                          });
                        },
                        icone: Icon(Icons.add),
                        corBotao: Colors.green,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: CalcularTamanho(
                                largura: MediaQuery.of(context).size.width)
                            .tamanho(10)),
                    child: Container(
                      width: 32.0.w,
                      height: 7.0.h,
                      child: Botao(
                        tamanhoFonte: 12.0.sp,
                        texto: "Fechar",
                        acao: () {
                          Navigator.pop(context);
                        },
                        icone: Icon(Icons.close),
                        corBotao: Colors.red,
                      ),
                    ),
                  )
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(right: 130),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
      ],
    );
  }
}
