import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cadastro extends StatelessWidget {
  final Function callback;

  Cadastro(this.callback);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final jogadorController = TextEditingController();

    Future<void> cadastrarJogador(String username) async {
      final response = await http.post(
        Uri.parse('https://par-impar.glitch.me/novo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['usuarios'] != null) {
          callback(username);
        } else {
          // Handle error
        }
      } else {
        // Handle error
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: jogadorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Jogador",
                ),
              ),
            ),
            ElevatedButton(
              child: const Text('Apostar'),
              onPressed: () {
                final jogador = jogadorController.text;
                cadastrarJogador(jogador);
              },
            ),
          ],
        ),
      ),
    );
  }
}
