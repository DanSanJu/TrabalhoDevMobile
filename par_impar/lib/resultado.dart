import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Resultado extends StatelessWidget {
  final Function callback;
  final String jogador1;
  final String jogador2;

  Resultado(this.callback, this.jogador1, this.jogador2);

  Future<Map<String, dynamic>> jogar() async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/jogar/$jogador1/$jogador2'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Handle error
      return {};
    }
  }

  Future<int> obterPontos(String username) async {
    final response = await http.get(Uri.parse('https://par-impar.glitch.me/pontos/$username'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['pontos'];
    } else {
      // Handle error
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: jogar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Text('Erro ao carregar resultado do jogo');
          } else {
            final resultado = snapshot.data!;
            if (resultado.containsKey('msg')) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(resultado['msg']),
                  ElevatedButton(
                    child: const Text('Nova Aposta'),
                    onPressed: () => callback(1),
                  ),
                ],
              );
            } else {
              return FutureBuilder<int>(
                future: obterPontos(jogador1),
                builder: (context, pontosSnapshot) {
                  if (pontosSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (pontosSnapshot.hasError) {
                    return const Text('Erro ao carregar pontos do jogador');
                  } else {
                    final pontosJogador1 = pontosSnapshot.data!;
                    return FutureBuilder<int>(
                      future: obterPontos(jogador2),
                      builder: (context, pontosSnapshot2) {
                        if (pontosSnapshot2.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (pontosSnapshot2.hasError) {
                          return const Text('Erro ao carregar pontos do oponente');
                        } else {
                          final pontosJogador2 = pontosSnapshot2.data!;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Vencedor: ${resultado['vencedor']['username']}'),
                              Text('Pontos do vencedor: ${resultado['vencedor']['username'] == jogador1 ? pontosJogador1 : pontosJogador2}'),
                              Text('Perdedor: ${resultado['perdedor']['username']}'),
                              Text('Pontos do perdedor: ${resultado['perdedor']['username'] == jogador1 ? pontosJogador1 : pontosJogador2}'),
                              ElevatedButton(
                                child: const Text('Nova Aposta'),
                                onPressed: () => callback(1),
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              );
            }
          }
        },
      ),
    );
  }
}
