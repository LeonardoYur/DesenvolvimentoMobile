import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(const Jogo());
}

class Jogo extends StatefulWidget {
  const Jogo({super.key});

  @override
  State<Jogo> createState() => _JogoState();
}

class _JogoState extends State<Jogo> {
  var jogador = 0;
  var maquina = 0;
  var resultado = "";
  var rodada = 0;

  late AudioPlayer player;

  var imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  ];

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  void tocarSom(String arquivo) async {
    await player.play(AssetSource(arquivo));
  }

  void jogar(int escolha) {
    setState(() {
      jogador = escolha;
      rodada++;

      if (rodada % 5 == 0) {
        if (jogador == 0) maquina = 2;
        if (jogador == 1) maquina = 0;
        if (jogador == 2) maquina = 1;
        resultado = "Você ganhou!";
        tocarSom("vitoria.mp3");
      } else {
        if (jogador == 0) maquina = 1;
        if (jogador == 1) maquina = 2;
        if (jogador == 2) maquina = 0;
        resultado = "A máquina ganhou!";
        tocarSom("derrota.mp3");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Image.network(imagens[jogador], width: 100),
            Image.network(imagens[maquina], width: 100),
            Text(resultado),
            TextButton(onPressed: () => jogar(0), child: const Text("Pedra")),
            TextButton(onPressed: () => jogar(1), child: const Text("Papel")),
            TextButton(onPressed: () => jogar(2), child: const Text("Tesoura")),
          ],
        ),
      ),
    );
  }
}
