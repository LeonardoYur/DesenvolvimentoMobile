import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const JogoCartasApp());
}

class JogoCartasApp extends StatelessWidget {
  const JogoCartasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo de Cartas',
      debugShowCheckedModeBanner: false,
      home: TelaJogoCartas(),
    );
  }
}

class TelaJogoCartas extends StatefulWidget {
  @override
  State<TelaJogoCartas> createState() => _TelaJogoCartasState();
}

class _TelaJogoCartasState extends State<TelaJogoCartas> {
  String? cartaJogadorUrl;
  String? cartaComputadorUrl;
  String? cartaJogadorCodigo;
  String? cartaComputadorCodigo;
  bool carregando = false;
  int vitoriasJogador = 0;
  int vitoriasComputador = 0;
  String mensagem = '';
  final Random rng = Random();

  // Ordem dos valores
  final Map<String, int> ordemValor = {
    'ACE': 14,
    'KING': 13,
    'QUEEN': 12,
    'JACK': 11,
    '10': 10,
    '9': 9,
    '8': 8,
    '7': 7,
    '6': 6,
    '5': 5,
    '4': 4,
    '3': 3,
    '2': 2
  };

  // Ordem de naipes caso precise comparar
  final Map<String, int> ordemNaipe = {
    'SPADES': 4,
    'HEARTS': 3,
    'DIAMONDS': 2,
    'CLUBS': 1
  };

  Future<void> puxarCartas() async {
    setState(() {
      carregando = true;
      mensagem = '';
      cartaJogadorUrl = null;
      cartaComputadorUrl = null;
    });

    try {
      // Puxar duas cartas de um novo deck
      final url =
          Uri.parse('https://deckofcardsapi.com/api/deck/new/draw/?count=2');
      final resp = await http.get(url);
      if (resp.statusCode != 200) throw Exception('Erro ao puxar cartas');

      final data = jsonDecode(resp.body);
      final cards = data['cards'] as List;
      if (cards.length < 2) throw Exception('Menos de 2 cartas retornadas');

      // Definimos: carta 0 = computador (esquerda), carta 1 = jogador (direita)
      final cartaComp = cards[0];
      final cartaJog = cards[1];

      cartaComputadorUrl = cartaComp['image'];
      cartaComputadorCodigo = cartaComp['code'];
      cartaJogadorUrl = cartaJog['image'];
      cartaJogadorCodigo = cartaJog['code'];

      // Escolher característica aleatória: 'valor' ou 'naipe'
      final caracteristica = rng.nextBool() ? 'valor' : 'naipe';

      String vencedor;
      if (caracteristica == 'valor') {
        final valComp = (cartaComp['value'] as String).toUpperCase();
        final valJog = (cartaJog['value'] as String).toUpperCase();
        final numComp = ordemValor[valComp] ?? 0;
        final numJog = ordemValor[valJog] ?? 0;
        if (numJog > numComp) {
          vencedor = 'jogador';
          vitoriasJogador++;
        } else if (numComp > numJog) {
          vencedor = 'computador';
          vitoriasComputador++;
        } else {
          vencedor = 'empate';
        }
      } else {
        final naiComp = (cartaComp['suit'] as String).toUpperCase();
        final naiJog = (cartaJog['suit'] as String).toUpperCase();
        final numComp = ordemNaipe[naiComp] ?? 0;
        final numJog = ordemNaipe[naiJog] ?? 0;
        if (numJog > numComp) {
          vencedor = 'jogador';
          vitoriasJogador++;
        } else if (numComp > numJog) {
          vencedor = 'computador';
          vitoriasComputador++;
        } else {
          vencedor = 'empate';
        }
      }

      setState(() {
        carregando = false;
        mensagem = 'Característica: $caracteristica. Vencedor: $vencedor';
      });
    } catch (e) {
      setState(() {
        carregando = false;
        mensagem = 'Erro: ${e.toString()}';
      });
    }
  }

  void resetarPlacar() {
    setState(() {
      vitoriasJogador = 0;
      vitoriasComputador = 0;
      mensagem = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo de Cartas'),
        actions: [
          IconButton(onPressed: resetarPlacar, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
                'Placar - Jogador: $vitoriasJogador  |  Computador: $vitoriasComputador'),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                children: [
                  // Carta do computador (esquerda)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Computador'),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Center(
                            child: cartaComputadorUrl != null
                                ? Image.network(cartaComputadorUrl!)
                                : const Text('Sem carta'),
                          ),
                        ),
                        Text(cartaComputadorCodigo ?? ''),
                      ],
                    ),
                  ),

                  // Carta do jogador (direita)
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Jogador'),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Center(
                            child: cartaJogadorUrl != null
                                ? Image.network(cartaJogadorUrl!)
                                : const Text('Sem carta'),
                          ),
                        ),
                        Text(cartaJogadorCodigo ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (mensagem.isNotEmpty) Text(mensagem),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: carregando ? null : puxarCartas,
              child: Text(carregando ? 'Jogando...' : 'Jogar uma rodada'),
            ),
            const SizedBox(height: 8),
            TextButton(
                onPressed: resetarPlacar, child: const Text('Resetar placar')),
          ],
        ),
      ),
    );
  }
}
