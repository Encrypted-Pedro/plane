import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Validador {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool email = false;
  bool senha = true;
  bool apelido = true;
  bool validarEmail(String email) {
    this.email = !email.contains('@');
    return this.email;
  }

  bool validarVazioTam(String senha, int tamanho, bool cpf, bool datanasc) {
    if (senha.length < tamanho) {
      this.senha = true;
    } else {
      this.senha = false;
      if (cpf == true) {
        if (!CPF.isValid(senha)) {
          this.senha = true;
        }
      }
      if (datanasc == true) {
        try {
          print(DateFormat.yMd().parse(senha).toString());
        } catch (e) {
          print("OLHA O ERRO AI: " + e.toString());
          this.senha = true;
        }
      }
    }
    return this.senha;
  }

  bool validarVazio(String apelido) {
    if (apelido != "") {
      this.apelido = false;
    } else {
      this.apelido = true;
    }
    return this.apelido;
  }

  validarUsuario(String usuario) async {
    bool valido = false;
    await db
        .collection("usuarios")
        .where("apelido", isEqualTo: usuario)
        .get()
        .then((value) {
      if (value.size > 0) {
        valido = true;
      }
    });
    return valido;
  }

  validarCpf(String cpf) async {
    bool valido = false;
    await db
        .collection("usuarios")
        .where("cpf", isEqualTo: cpf)
        .get()
        .then((value) {
      if (value.size > 0) {
        valido = true;
      }
    });
    return valido;
  }

  conferirSenha(String senha, String confSenha, String email) async {
    print("XIZ VIDEO");
    bool valido = false;
    try {
      print("CHEGA " + "| Email: " + email + " | Senha: " + confSenha);
      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email.trim(), password: confSenha))
          .user;
      if (user != null) {
        valido = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "wrong-password") {
        valido = false;
      }
    } catch (ex) {
      print(ex);
    }
    return valido;
  }

  bool senhasIguais(String senha, String confSenha) {
    bool valido = true;
    if (senha == confSenha) {
      valido = false;
    }
    return valido;
  }
}
