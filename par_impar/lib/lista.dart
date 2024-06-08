import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Lista extends StatelessWidget {
  final Function(String) callback;

  Lista(this.callback);

  Future<List<Map<String, dynamic>>> obterJogadores() async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/jogadores'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['jogadores']);
    } else {
      // Handle error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: obterJogadores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar lista de jogadores');
          } else {
            final jogadores = snapshot.data!;
            return ListView.builder(
              itemCount: jogadores.length,
              itemBuilder: (context, index) {
                final jogador = jogadores[index];
                return ListTile(
                  title: Text(jogador['username']),
                  subtitle: Text('Pontos: ${jogador['pontos']}'),
                  onTap: () => callback(jogador['username']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
