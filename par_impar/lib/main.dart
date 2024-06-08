import 'package:flutter/material.dart';
import 'package:par_impar/aposta.dart';
import 'package:par_impar/cadastro.dart';
import 'package:par_impar/lista.dart';
import 'package:par_impar/resultado.dart';

void main() {
  runApp(ParImpar());
}

class ParImpar extends StatefulWidget {
  @override
  State<ParImpar> createState() => ParImparState();
}

class ParImparState extends State<ParImpar> {
  var telaAtual = 0;
  var jogador = "";
  var oponente = "";

  void trocaTela(int idNovaTela) {
    setState(() {
      telaAtual = idNovaTela;
    });
  }

  void cadastro(String nome) {
    jogador = nome;
    trocaTela(1);
  }

  void selecionarOponente(String oponenteSelecionado) {
    oponente = oponenteSelecionado;
    trocaTela(3);
  }

  Widget exibirTela() {
    if (telaAtual == 0) {
      return Cadastro(cadastro);
    } else if (telaAtual == 1) {
      return Aposta(trocaTela, jogador);
    } else if (telaAtual == 2) {
      return Lista(selecionarOponente);
    } else {
      return Resultado(trocaTela, jogador, oponente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: exibirTela(),
    );
  }
}
