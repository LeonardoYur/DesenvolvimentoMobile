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
  final agora = DateTime.now();

  String diaDaSemana(int numero) {
    switch (numero) {
      case 1:
        return "Segunda";
      case 2:
        return "Terça";
      case 3:
        return "Quarta";
      case 4:
        return "Quinta";
      case 5:
        return "Sexta";
      case 6:
        return "Sábado";
      case 7:
        return "Domingo";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    int diasNoMes = DateUtils.getDaysInMonth(agora.year, agora.month);

    return Scaffold(
      appBar: AppBar(title: const Text("Calendário")),
      body: ListView.builder(
        itemCount: diasNoMes,
        itemBuilder: (context, index) {
          final dia = index + 1;
          final data = DateTime(agora.year, agora.month, dia);
          final semana = diaDaSemana(data.weekday);

          return TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Resultado(dia: dia, semana: semana),
                ),
              );
            },
            child: Text("$dia"),
          );
        },
      ),
    );
  }
}

class Resultado extends StatelessWidget {
  final int dia;
  final String semana;
  const Resultado({super.key, required this.dia, required this.semana});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultado")),
      body: Center(
        child: Text("Apertado: $semana, $dia!"),
      ),
    );
  }
}
