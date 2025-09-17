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
                    builder: (context) => Resultado(raio: raio),
                  ),
                );
              },
              child: const Text("Calcular"),
            ),
          ],
        ),
      ),
    );
  }
}

class Resultado extends StatelessWidget {
  final double raio;
  const Resultado({super.key, required this.raio});

  @override
  Widget build(BuildContext context) {
    double area = pi * raio * raio;
    return Scaffold(
      body: Center(
        child: Text("Área: ${area}"),
      ),
    );
  }
}
