import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MaterialApp(home: NovoTexto()));
}

class NovoTexto extends StatefulWidget {
  const NovoTexto({super.key});

  @override
  State<NovoTexto> createState() => _NovoTextoState();
}

class _NovoTextoState extends State<NovoTexto> {
  late TextEditingController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controlador,
            ),
            TextButton(
              onPressed: () {
                double raio = double.tryParse(_controlador.text) ?? 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Resultado(texto: "Diâmetro: ${2 * raio}")),
                );
              },
              child: const Text("Ver diâmetro"),
            ),
            TextButton(
              onPressed: () {
                double raio = double.tryParse(_controlador.text) ?? 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Resultado(
                          texto: "Circunferência: ${(2 * pi * raio)}")),
                );
              },
              child: const Text("Ver circunferência"),
            ),
            TextButton(
              onPressed: () {
                double raio = double.tryParse(_controlador.text) ?? 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Resultado(texto: "Área: ${(pi * raio * raio)}")),
                );
              },
              child: const Text("Ver área"),
            ),
          ],
        ),
      ),
    );
  }
}

class Resultado extends StatelessWidget {
  final String texto;
  const Resultado({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(texto)),
    );
  }
}
