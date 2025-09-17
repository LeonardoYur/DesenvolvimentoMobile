import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CadastroAluno()));
}

class CadastroAluno extends StatefulWidget {
  const CadastroAluno({super.key});

  @override
  State<CadastroAluno> createState() => _CadastroAlunoState();
}

class _CadastroAlunoState extends State<CadastroAluno> {
  late TextEditingController _controladorNome;
  late TextEditingController _controladorMatricula;

  @override
  void initState() {
    super.initState();
    _controladorNome = TextEditingController();
    _controladorMatricula = TextEditingController();
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorMatricula.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controladorNome,
            ),
            TextField(
              controller: _controladorMatricula,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LancarNotas(
                      nome: _controladorNome.text,
                      matricula: _controladorMatricula.text,
                    ),
                  ),
                );
              },
              child: const Text("Próximo"),
            ),
          ],
        ),
      ),
    );
  }
}

class LancarNotas extends StatefulWidget {
  final String nome;
  final String matricula;

  const LancarNotas({super.key, required this.nome, required this.matricula});

  @override
  State<LancarNotas> createState() => _LancarNotasState();
}

class _LancarNotasState extends State<LancarNotas> {
  late TextEditingController _controlador;
  List<double> notas = [];

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
                double nota = double.tryParse(_controlador.text) ?? 0;
                setState(() {
                  notas.add(nota);
                });
                _controlador.clear();
              },
              child: const Text("Adicionar nota"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisualizarAluno(
                      nome: widget.nome,
                      matricula: widget.matricula,
                      notas: notas,
                    ),
                  ),
                );
              },
              child: const Text("Ver informações"),
            ),
          ],
        ),
      ),
    );
  }
}

class VisualizarAluno extends StatelessWidget {
  final String nome;
  final String matricula;
  final List<double> notas;

  const VisualizarAluno({
    super.key,
    required this.nome,
    required this.matricula,
    required this.notas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Nome: $nome"),
            Text("Matrícula: $matricula"),
            Expanded(
              child: ListView.builder(
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  return Text("Nota: ${notas[index]}");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
