import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ex1 Calculadora SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String tela = '0';
  double memoria = 0.0;
  double? valorAnterior;
  String operador = '';
  final db = DatabaseHelper.instancia;

  void adicionarNumero(String numero) {
    setState(() {
      if (tela == '0') tela = '';
      tela += numero;
    });
  }

  void definirOperador(String op) {
    valorAnterior = double.tryParse(tela);
    operador = op;
    setState(() => tela = '0');
  }

  Future calcular() async {
    if (valorAnterior == null) return;
    double atual = double.parse(tela);
    double resultado = 0;

    switch (operador) {
      case '+':
        resultado = valorAnterior! + atual;
        break;
      case '-':
        resultado = valorAnterior! - atual;
        break;
      case '*':
        resultado = valorAnterior! * atual;
        break;
      case '/':
        resultado = valorAnterior! / atual;
        break;
    }

    await db.inserirOperacao(
        '$valorAnterior $operador $atual', resultado.toString());
    await db.salvarDado('tela', resultado.toString());

    setState(() {
      tela = resultado.toString();
    });
  }

  void limpar() => setState(() => tela = '0');

  Future memoriaOperacao(String tipo) async {
    switch (tipo) {
      case 'MC':
        memoria = 0;
        break;
      case 'MR':
        tela = memoria.toString();
        break;
      case 'M+':
        memoria += double.parse(tela);
        break;
      case 'M-':
        memoria -= double.parse(tela);
        break;
    }
    await db.salvarDado('memoria', memoria.toString());
    setState(() {});
  }

  Widget botao(String texto, Function() acao) {
    return ElevatedButton(
      onPressed: acao,
      style: ElevatedButton.styleFrom(minimumSize: const Size(70, 70)),
      child: Text(texto, style: const TextStyle(fontSize: 22)),
    );
  }

  void abrirHistorico() async {
    final operacoes = await db.listarOperacoes();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HistoricoPage(operacoes: operacoes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora com SQLite'),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: abrirHistorico)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(tela, style: const TextStyle(fontSize: 40)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var n in ['7', '8', '9', '4', '5', '6', '1', '2', '3', '0'])
                botao(n, () => adicionarNumero(n)),
              botao('+', () => definirOperador('+')),
              botao('-', () => definirOperador('-')),
              botao('*', () => definirOperador('*')),
              botao('/', () => definirOperador('/')),
              botao('=', calcular),
              botao('C', limpar),
              botao('MC', () => memoriaOperacao('MC')),
              botao('MR', () => memoriaOperacao('MR')),
              botao('M+', () => memoriaOperacao('M+')),
              botao('M-', () => memoriaOperacao('M-')),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoricoPage extends StatelessWidget {
  final List<Map<String, dynamic>> operacoes;
  const HistoricoPage({super.key, required this.operacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: ListView.builder(
        itemCount: operacoes.length,
        itemBuilder: (ctx, i) {
          final o = operacoes[i];
          return ListTile(
            title: Text('${o['expressao']} = ${o['resultado']}'),
            subtitle: Text(o['timestamp']),
          );
        },
      ),
    );
  }
}
