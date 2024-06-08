import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Aposta extends StatefulWidget {
  final Function callback;
  final String jogador;

  Aposta(this.callback, this.jogador);

  @override
  State<StatefulWidget> createState() => ApostaState(callback, jogador);
}

class ApostaState extends State<Aposta> {
  final Function callback;
  final String jogador;
  int dedos = 1;
  int valorAposta = 0;
  int parImpar = 0;

  ApostaState(this.callback, this.jogador);

  Future<void> efetuarAposta() async {
    final response = await http.post(
      Uri.parse('https://par-impar.glitch.me/aposta'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': jogador,
        'valor': valorAposta,
        'parimpar': parImpar,
        'numero': dedos,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['msg'] != null) {
        callback(2);
      } else {
        // Handle error
      }
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aposta $jogador')),
      body: Column(
        children: [
          const Text("Escolha o número (1-5)"),
          Slider(
            label: "$dedos",
            min: 1,
            divisions: 5,
            max: 5,
            value: dedos.toDouble(),
            onChanged: (val) {
              setState(() {
                dedos = val.toInt();
              });
            },
          ),
          const Text("Valor da aposta"),
          Slider(
            label: "$valorAposta",
            min: 0,
            divisions: 10,
            max: 100,
            value: valorAposta.toDouble(),
            onChanged: (val) {
              setState(() {
                valorAposta = val.toInt();
              });
            },
          ),
          Row(
            children: [
              Radio(
                value: 2,
                groupValue: parImpar,
                onChanged: (int? value) {
                  setState(() {
                    parImpar = 2;
                  });
                },
              ),
              const Text('Par'),
              Radio(
                value: 1,
                groupValue: parImpar,
                onChanged: (int? value) {
                  setState(() {
                    parImpar = 1;
                  });
                },
              ),
              const Text('Impar'),
            ],
          ),
          ElevatedButton(
            child: const Text('Escolher Adversário'),
            onPressed: efetuarAposta,
          ),
        ],
      ),
    );
  }
}
