import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: NovoTexto()));
}

class NovoTexto extends StatefulWidget {
  const NovoTexto({super.key});

  @override
  State<NovoTexto> createState() => _NovoTextoState();
}

class _NovoTextoState extends State<NovoTexto> {
  Future<void> selecionarData(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      final hoje = DateTime.now();
      int idade = hoje.year - data.year;
      if (hoje.month < data.month ||
          (hoje.month == data.month && hoje.day < data.day)) {
        idade--;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultado(idade: idade),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => selecionarData(context),
          child: const Text("Selecionar nascimento"),
        ),
      ),
    );
  }
}

class Resultado extends StatelessWidget {
  final int idade;
  const Resultado({super.key, required this.idade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Idade: $idade anos")),
    );
  }
}
