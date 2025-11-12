import 'package:flutter/material.dart';
import 'localizacao.dart';
import 'clima.dart';

void main() {
  runApp(const ClimaApp());
}

class ClimaApp extends StatefulWidget {
  const ClimaApp({super.key});

  @override
  State<ClimaApp> createState() => _ClimaAppState();
}

class _ClimaAppState extends State<ClimaApp> {
  Localizacao local = Localizacao();
  Clima clima = Clima();
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  void buscarDados() async {
    try {
      await local.pegaLocalizacaoAtual();
      await clima.buscarClima(local.latitude!, local.longitude!);
      setState(() {
        carregando = false;
      });
    } catch (e) {
      setState(() {
        carregando = false;
        erro = e.toString();
      });
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clima Atual'),
          backgroundColor: Colors.blue[900],
        ),
        body: Center(
          child: carregando
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Carregando dados...'),
                  ],
                )
              : erro != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 50, color: Colors.red),
                          const SizedBox(height: 20),
                          Text(
                            'Erro: $erro',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                carregando = true;
                                erro = null;
                              });
                              buscarDados();
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wb_sunny,
                              size: 80, color: Colors.orange),
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Temperatura: ${clima.temperatura?.toStringAsFixed(1) ?? "N/A"}°C',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Umidade: ${clima.umidade ?? "N/A"}%',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Velocidade do vento: ${clima.velocidadeVento?.toStringAsFixed(1) ?? "N/A"} m/s',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
