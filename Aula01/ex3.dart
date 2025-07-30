import 'dart:core';

void main() {
  final DateTime agora = DateTime.now();
  final DateTime primeiroDiaDoMes = DateTime(agora.year, agora.month, 1);

  const String cabecalho = "| D | S | T | Q | Q | S | S |";
  print(cabecalho);

  final int diaDaSemanaInicial = primeiroDiaDoMes.weekday % 7;

  final StringBuffer bufferLinha = StringBuffer();

  for (int i = 0; i < diaDaSemanaInicial; i++) {
    bufferLinha.write("|   ");
  }

  for (int dia = 1; dia <= agora.day; dia++) {
    final int colunaAtual = (diaDaSemanaInicial + dia - 1) % 7;

    if (colunaAtual == 0 && dia > 1) {
      bufferLinha.write("|\n");
      print(bufferLinha.toString());
      bufferLinha.clear();
    }

    final String diaStr = dia.toString().padLeft(2, ' ');
    bufferLinha.write("|$diaStr ");
  }

  bufferLinha.write("|");
  print(bufferLinha.toString());
}