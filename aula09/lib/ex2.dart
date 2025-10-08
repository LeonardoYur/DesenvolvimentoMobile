import 'package:flutter/material.dart';

void main() {
  runApp(const PetApp());
}

const Color fundo = Color(0xFF1E164B);
const Color selecionada = Color.fromARGB(255, 45, 11, 237);

enum TipoPet { gato, cachorro }

class PetApp extends StatefulWidget {
  const PetApp({super.key});

  @override
  State<PetApp> createState() => _PetAppState();
}

class _PetAppState extends State<PetApp> {
  TipoPet petSelecionado = TipoPet.gato;
  double peso = 5.0;
  int idade = 1;
  double idadeFisiologica = 0.0;

  void selecionarPet(TipoPet tipo) {
    setState(() {
      petSelecionado = tipo;
      calcularIdadeFisiologica();
    });
  }

  void calcularIdadeFisiologica() {
    if (petSelecionado == TipoPet.gato) {
      if (idade == 1) {
        idadeFisiologica = 15;
      } else if (idade == 2) {
        idadeFisiologica = 24;
      } else {
        idadeFisiologica = 24 + (idade - 2) * 4;
      }
    } else {
      if (peso < 9) {
        if (idade == 1) {
          idadeFisiologica = 15;
        } else if (idade == 2) {
          idadeFisiologica = 24;
        } else {
          idadeFisiologica = 24 + (idade - 2) * 4;
        }
      } else if (peso >= 9 && peso < 23) {
        if (idade == 1) {
          idadeFisiologica = 15;
        } else if (idade == 2) {
          idadeFisiologica = 24;
        } else {
          idadeFisiologica = 24 + (idade - 2) * 5;
        }
      } else {
        if (idade == 1) {
          idadeFisiologica = 12;
        } else if (idade == 2) {
          idadeFisiologica = 22;
        } else {
          idadeFisiologica = 22 + (idade - 2) * 7;
        }
      }
    }
  }

  void incrementarIdade() {
    setState(() {
      idade++;
      calcularIdadeFisiologica();
    });
  }

  void decrementarIdade() {
    if (idade > 1) {
      setState(() {
        idade--;
        calcularIdadeFisiologica();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Idade Pet')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarPet(TipoPet.gato),
                      child: Caixa(
                        cor: petSelecionado == TipoPet.gato
                            ? selecionada
                            : fundo,
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, color: Colors.white, size: 80),
                            SizedBox(height: 15),
                            Text('GATO',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selecionarPet(TipoPet.cachorro),
                      child: Caixa(
                        cor: petSelecionado == TipoPet.cachorro
                            ? selecionada
                            : fundo,
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, color: Colors.white, size: 80),
                            SizedBox(height: 15),
                            Text('CACHORRO',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Caixa(
                cor: fundo,
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Peso:',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 15),
                    Text('${peso.round()} kg',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white)),
                    Slider(
                      min: 1.0,
                      max: 50.0,
                      value: peso,
                      onChanged: (double valor) {
                        setState(() {
                          peso = valor;
                          calcularIdadeFisiologica();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Idade:',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 15),
                          Text('$idade',
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white)),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: incrementarIdade,
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueGrey),
                                child: const Icon(Icons.add),
                              ),
                              TextButton(
                                onPressed: decrementarIdade,
                                child: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: fundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Idade Fisiológica:',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 15),
                          Text('${idadeFisiologica.toStringAsFixed(0)} anos',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({super.key, required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
