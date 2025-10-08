import 'package:flutter/material.dart';
import 'dart:math';

const corAtivaCartao = Color(0xFF1D1E33);
const corInativaCartao = Color(0xFF111328);
const corContainerInferior = Color(0xFFEB1555);
const alturaContainerInferior = 80.0;

const estiloLabel = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const estiloNumero = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

enum Genero {
  masculino,
  feminino,
}

void main() => runApp(const CalculadoraIMC());

class CalculadoraIMC extends StatelessWidget {
  const CalculadoraIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  Genero? generoSelecionado;
  int altura = 180;
  int peso = 60;
  int idade = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CALCULADORA IMC'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () =>
                        setState(() => generoSelecionado = Genero.masculino),
                    cor: generoSelecionado == Genero.masculino
                        ? corAtivaCartao
                        : corInativaCartao,
                    filhoCartao:
                        ConteudoIcone(icone: Icons.male, label: 'MASCULINO'),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () =>
                        setState(() => generoSelecionado = Genero.feminino),
                    cor: generoSelecionado == Genero.feminino
                        ? corAtivaCartao
                        : corInativaCartao,
                    filhoCartao:
                        ConteudoIcone(icone: Icons.female, label: 'FEMININO'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CartaoPadrao(
              cor: corAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('ALTURA', style: estiloLabel),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(altura.toString(), style: estiloNumero),
                      const Text('cm', style: estiloLabel),
                    ],
                  ),
                  Slider(
                    value: altura.toDouble(),
                    min: 120.0,
                    max: 220.0,
                    activeColor: const Color(0xFFEB1555),
                    inactiveColor: const Color(0xFF8D8E98),
                    onChanged: (double novoValor) =>
                        setState(() => altura = novoValor.round()),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CartaoPadrao(
                    cor: corAtivaCartao,
                    filhoCartao: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('PESO', style: estiloLabel),
                        Text(peso.toString(), style: estiloNumero),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BotaoArredondado(
                              icone: Icons.remove,
                              aoPressionar: () => setState(() => peso--),
                            ),
                            const SizedBox(width: 10.0),
                            BotaoArredondado(
                              icone: Icons.add,
                              aoPressionar: () => setState(() => peso++),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    cor: corAtivaCartao,
                    filhoCartao: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('IDADE', style: estiloLabel),
                        Text(idade.toString(), style: estiloNumero),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BotaoArredondado(
                              icone: Icons.remove,
                              aoPressionar: () => setState(() => idade--),
                            ),
                            const SizedBox(width: 10.0),
                            BotaoArredondado(
                              icone: Icons.add,
                              aoPressionar: () => setState(() => idade++),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BotaoInferior(
            textoBotao: 'CALCULAR',
            aoPressionar: () {
              Calculadora crebro = Calculadora(altura: altura, peso: peso);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaginaResultados(
                          resultadoIMC: crebro.calcularIMC(),
                          resultadoTexto: crebro.obterResultado(),
                          interpretacao: crebro.obterInterpretacao(),
                        )),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PaginaResultados extends StatelessWidget {
  const PaginaResultados(
      {super.key,
      required this.resultadoIMC,
      required this.resultadoTexto,
      required this.interpretacao});

  final String resultadoIMC;
  final String resultadoTexto;
  final String interpretacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CALCULADORA IMC')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Expanded(
            child: Center(
              child: Text('Seu Resultado',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 5,
            child: CartaoPadrao(
              cor: corAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(resultadoTexto.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF24D876),
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(resultadoIMC,
                      style: const TextStyle(
                          fontSize: 100, fontWeight: FontWeight.bold)),
                  Text(interpretacao,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22)),
                ],
              ),
            ),
          ),
          BotaoInferior(
            textoBotao: 'RECALCULAR',
            aoPressionar: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

class BotaoInferior extends StatelessWidget {
  const BotaoInferior(
      {super.key, required this.textoBotao, required this.aoPressionar});

  final String textoBotao;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        color: corContainerInferior,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: alturaContainerInferior,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
            child: Text(textoBotao,
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

class BotaoArredondado extends StatelessWidget {
  const BotaoArredondado(
      {super.key, required this.icone, required this.aoPressionar});

  final IconData icone;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      constraints: const BoxConstraints.tightFor(width: 56.0, height: 56.0),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      onPressed: aoPressionar,
      child: Icon(icone),
    );
  }
}

class CartaoPadrao extends StatelessWidget {
  const CartaoPadrao(
      {super.key, required this.cor, this.filhoCartao, this.aoPressionar});

  final Color cor;
  final Widget? filhoCartao;
  final VoidCallback? aoPressionar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: filhoCartao,
      ),
    );
  }
}

class ConteudoIcone extends StatelessWidget {
  const ConteudoIcone({super.key, required this.icone, required this.label});

  final IconData icone;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icone, size: 80.0),
        const SizedBox(height: 15.0),
        Text(label, style: estiloLabel),
      ],
    );
  }
}

class Calculadora {
  Calculadora({required this.altura, required this.peso});

  final int altura;
  final int peso;

  late double _imc;

  String calcularIMC() {
    _imc = peso / pow(altura / 100, 2);
    return _imc.toStringAsFixed(1);
  }

  String obterResultado() {
    if (_imc >= 25) {
      return 'Acima do peso';
    } else if (_imc > 18.5) {
      return 'Normal';
    } else {
      return 'Abaixo do peso';
    }
  }

  String obterInterpretacao() {
    if (_imc >= 25) {
      return 'Você está com o peso acima do normal. Tente se exercitar mais.';
    } else if (_imc > 18.5) {
      return 'Excelente! Seu peso está normal.';
    } else {
      return 'Você está com o peso abaixo do normal. Tente comer um pouco mais.';
    }
  }
}
