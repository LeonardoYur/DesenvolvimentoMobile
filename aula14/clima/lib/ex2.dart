import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const AppDicionario());
}

class AppDicionario extends StatelessWidget {
  const AppDicionario({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dicionário',
      debugShowCheckedModeBanner: false,
      home: TelaDicionario(),
    );
  }
}

class TelaDicionario extends StatefulWidget {
  @override
  State<TelaDicionario> createState() => _TelaDicionarioState();
}

class _TelaDicionarioState extends State<TelaDicionario> {
  final TextEditingController controladorPalavra = TextEditingController();
  bool carregando = false;
  String? definicao;
  String mensagemErro = '';

  Future<void> buscarDefinicao() async {
    final palavra = controladorPalavra.text.trim();
    if (palavra.isEmpty) {
      setState(() => mensagemErro = 'Digite uma palavra em inglês.');
      return;
    }
    setState(() {
      carregando = true;
      definicao = null;
      mensagemErro = '';
    });

    try {
      final url = Uri.parse(
          'https://api.dictionaryapi.dev/api/v2/entries/en/${Uri.encodeComponent(palavra)}');
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Palavra não encontrada ou erro ${resp.statusCode}');
      }
      final data = jsonDecode(resp.body);
      // O retorno é uma lista; acessamos [0].meanings[0].definitions[0].definition
      if (data is List && data.isNotEmpty) {
        final primeira = data[0];
        final definitions = primeira['meanings']?[0]?['definitions'];
        if (definitions != null &&
            definitions is List &&
            definitions.isNotEmpty) {
          setState(() {
            definicao = definitions[0]['definition']?.toString() ??
                'Definição não disponível';
            carregando = false;
          });
          return;
        }
      }
      throw Exception('Definição não encontrada');
    } catch (e) {
      setState(() {
        carregando = false;
        mensagemErro = 'Erro: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    controladorPalavra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dicionário (dictionaryapi.dev)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controladorPalavra,
              decoration: const InputDecoration(
                labelText: 'Palavra (inglês)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: carregando ? null : buscarDefinicao,
              child: Text(carregando ? 'Buscando...' : 'Buscar Definição'),
            ),
            const SizedBox(height: 20),
            if (mensagemErro.isNotEmpty)
              Text(mensagemErro, style: const TextStyle(color: Colors.red)),
            if (definicao != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Definição: $definicao'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
