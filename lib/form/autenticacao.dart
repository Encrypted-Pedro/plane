import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:plane/form/dialogo_info.dart';
import 'package:plane/funcoes/calculartamanho.dart';
import 'package:plane/principal.dart';
import 'package:plane/telas_principal/manutencao_bloq.dart';

class Autenticar {
  FirebaseFirestore db = FirebaseFirestore.instance;
  logar(String email, String senha, BuildContext context) async {
    int logou = 0;
    try {
      print("CHEGA");
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email.trim(), password: senha))
          .user;
      if (user != null) {
        String uid = user.uid;
        int liberado = 0;
        DocumentSnapshot doc = await db.collection("usuarios").doc(uid).get();
        doc.data().forEach((key, value) {
          if (key == "libarado") {
            liberado = value;
          }
        });
        if (liberado == 2) {
          DialogoInfo(
              context: context,
              titulo: "Bloqueado",
              mensagem: "Seu usuário foi bloqueado!",
              corBotao: Colors.red);
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Principal(),
              ));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        DialogoInfo(
            context: context,
            titulo: "Erro de login",
            mensagem: "E-mail inválido",
            corBotao: Colors.red);
      }
      if (e.code == "user-not-found") {
        DialogoInfo(
            context: context,
            titulo: "Erro de login",
            mensagem: "E-mail não cadastrado",
            corBotao: Colors.red);
      }
      if (e.code == "wrong-password") {
        DialogoInfo(
            context: context,
            titulo: "Erro de login",
            mensagem: "Dados de conexão incorretos, verifique!",
            corBotao: Colors.red);
      }
      if (e.code == "too-many-requests") {
        DialogoInfo(
            context: context,
            titulo: "Erro de login",
            mensagem:
                "Você falhou em várias tentativas de login, aguarde um pouco e tente novamente!",
            corBotao: Colors.red);
      }
      return logou;
    } catch (ex) {
      print(ex);
    }
  }

  void cadastrar(
      String nome,
      String rg,
      String cpf,
      String datanasc,
      String enderenco,
      String bairro,
      String numero,
      String cep,
      String cidade,
      String estado,
      String celular,
      String apelido,
      String email,
      String senha,
      BuildContext context) async {
    email = email.trim();
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);
      if (user != null) {
        await db.collection("usuarios").doc(user.user.uid).set({
          "nome": nome,
          "rg": rg,
          "cpf": cpf,
          "datanasc": datanasc,
          "endereco": enderenco,
          "bairro": bairro,
          "numero": numero,
          "cep": cep,
          "cidade": cidade,
          "estado": estado,
          "celular": celular,
          "email": email,
          "apelido": apelido,
          "libarado": 0
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Principal(),
            ));
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Ocorreu um erro ao tentar cadastrar, tente novamente";
      if (e.code == "invalid-email") {
        msg = "E-mail inválido, verifique";
      } else if (e.code == "email-already-in-use") {
        msg = "E-mail já cadastrado!";
      }
      print(e.code);
      DialogoInfo(
          context: context,
          titulo: "Erro ao cadastrar",
          mensagem: msg,
          corBotao: Colors.red);
    } catch (e) {
      print("OUTRO ERRO: " + e);
    }
  }

  void editarCadastro(
      String datanasc,
      String enderenco,
      String bairro,
      String numero,
      String cep,
      String cidade,
      String estado,
      String celular,
      String senha,
      BuildContext context) async {
    try {
      String uid = Autenticar().usuarioLogado(context);
      if (uid != null) {
        await db.collection("usuarios").doc(uid).update({
          "datanasc": datanasc,
          "endereco": enderenco,
          "bairro": bairro,
          "numero": numero,
          "cep": cep,
          "cidade": cidade,
          "estado": estado,
          "celular": celular,
        });
        if (senha != "") {
          print("SENHA: " + senha);
          FirebaseAuth auth = FirebaseAuth.instance;
          User user = auth.currentUser;
          await user.updatePassword(senha);
        }
        DialogoInfo(
            context: context,
            titulo: "Alteração realizada",
            mensagem: null,
            rotaSaida: "/principal",
            icone: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: CalcularTamanho(largura: MediaQuery.of(context).size.width)
                  .tamanho(80),
            ));
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/", (bool) => false);
      }
    } on FirebaseAuthException catch (e) {
      String msg = "Ocorreu um erro ao tentar cadastrar, tente novamente";
      if (e.code == "invalid-email") {
        msg = "E-mail inválido, verifique";
      } else if (e.code == "email-already-in-use") {
        msg = "E-mail já cadastrado!";
      }
      print(e.code);
      DialogoInfo(
          context: context,
          titulo: "Erro ao Salvar dados",
          mensagem: msg,
          corBotao: Colors.red);
    } catch (e) {
      print("OUTRO ERRO: " + e);
    }
  }

  usuarioBloqueado(BuildContext context, String uid) async {
    int liberado = 0;
    DocumentSnapshot doc = await db.collection("usuarios").doc(uid).get();
    PackageInfo info = await PackageInfo.fromPlatform();
    String versao = info.version;
    int manutencao = 0;
    String versaoAtual = "";
    await db.collection("app").doc("gerenciamento").get().then((value) {
      manutencao = value["manutencao"];
      versaoAtual = value["versao"];
    });
    doc.data().forEach((key, value) {
      if (key == "libarado") {
        liberado = value;
        print("VERSAO: " + versao + " | VERSAO ATUAL: " + versaoAtual);
        if (versao != versaoAtual) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ManutencaoBloq(2),
              ),
              (route) => false);
        } else if (manutencao == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ManutencaoBloq(1),
              ),
              (route) => false);
        }
      }
    });
    if (liberado == 2) {
      await FirebaseAuth.instance.signOut().then((value) =>
          Navigator.pushNamedAndRemoveUntil(context, "/", (bool) => false));
    }
    return liberado;
  }

  usuarioLogado(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    String uid = "";
    if (user != null) {
      uid = user.uid;
    } else {
      Navigator.pushNamedAndRemoveUntil(context, "/", (bool) => false);
    }
    usuarioBloqueado(context, uid);
    return uid;
  }
}
