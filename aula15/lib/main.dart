import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as htmldom; // ALIAS PARA EVITAR CONFLITO
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({required this.prefs, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Wiki Learner',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => TelaInicio(prefs: prefs),
        '/palavras': (_) => TelaPalavras(prefs: prefs),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/definicao') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) =>
                TelaDefinicao(palavra: args['palavra'], prefs: prefs),
          );
        }
        return null;
      },
    );
  }
}

class TelaInicio extends StatefulWidget {
  final SharedPreferences prefs;
  const TelaInicio({required this.prefs, super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final TextEditingController controladorUrl = TextEditingController();
  bool carregando = false;
  String erro = '';
  String paragrafo = '';
  List<String> palavrasExibidas = [];
  Set<String> palavrasCompreendidas = {};

  @override
  void initState() {
    super.initState();
    _carregarPalavrasCompreendidas();
  }

  Future<void> _carregarPalavrasCompreendidas() async {
    final lista = widget.prefs.getStringList('palavras_compreendidas') ?? [];
    setState(() {
      palavrasCompreendidas = lista.map((e) => e.toLowerCase()).toSet();
    });
  }

  Future<void> _buscarParagrafo() async {
    final url = controladorUrl.text.trim();

    if (url.isEmpty) {
      setState(() => erro = 'Cole uma URL da Wikipedia em inglês.');
      return;
    }

    setState(() {
      carregando = true;
      erro = '';
      paragrafo = '';
      palavrasExibidas = [];
    });

    try {
      final resp = await http.get(Uri.parse(url));
      final doc = parser.parse(resp.body);

      final htmldom.Element? content = doc.querySelector('#mw-content-text');
      List<htmldom.Element> paragrafos =
          content?.querySelectorAll('p').toList() ??
              doc.querySelectorAll('p').toList();

      String? primeiro;
      for (var p in paragrafos) {
        final texto = p.text.trim();
        if (texto.isNotEmpty && texto.length > 40) {
          primeiro = texto;
          break;
        }
      }

      if (primeiro == null) {
        throw Exception("Parágrafo não encontrado.");
      }

      setState(() {
        paragrafo = primeiro!;
        palavrasExibidas = primeiro.split(RegExp(r'\s+'));
      });
    } catch (e) {
      setState(() => erro = e.toString());
    } finally {
      setState(() => carregando = false);
    }
  }

  bool _ehCompreendida(String token) {
    final palavra = token.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
    return palavrasCompreendidas.contains(palavra);
  }

  String _normalizar(String token) {
    return token.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Wiki App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/palavras').then((_) {
                _carregarPalavrasCompreendidas();
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controladorUrl,
              decoration: const InputDecoration(
                labelText: 'URL da Wikipedia (EN)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: carregando ? null : _buscarParagrafo,
              child: const Text("Extrair Parágrafo"),
            ),
            const SizedBox(height: 10),
            if (erro.isNotEmpty)
              Text(erro, style: const TextStyle(color: Colors.red)),
            if (carregando) const CircularProgressIndicator(),
            if (paragrafo.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: palavrasExibidas.map((token) {
                      final palavra = _normalizar(token);

                      if (palavra.isEmpty) return Text(token);

                      if (_ehCompreendida(token)) {
                        return Chip(
                          label: Text(token),
                          backgroundColor: Colors.grey.shade300,
                        );
                      }

                      return ActionChip(
                        label: Text(token),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/definicao',
                            arguments: {"palavra": palavra},
                          ).then((_) {
                            _carregarPalavrasCompreendidas();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TelaDefinicao extends StatefulWidget {
  final String palavra;
  final SharedPreferences prefs;
  const TelaDefinicao({required this.palavra, required this.prefs, super.key});

  @override
  State<TelaDefinicao> createState() => _TelaDefinicaoState();
}

class _TelaDefinicaoState extends State<TelaDefinicao> {
  Map<String, dynamic>? dados;
  bool carregando = true;
  bool erro = false;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      final url =
          "https://api.dictionaryapi.dev/api/v2/entries/en/${widget.palavra}";
      final resp = await http.get(Uri.parse(url));

      final json = jsonDecode(resp.body);
      dados = json[0];

      setState(() => carregando = false);
    } catch (e) {
      setState(() {
        carregando = false;
        erro = true;
      });
    }
  }

  void _marcarCompreendido() async {
    final lista = widget.prefs.getStringList('palavras_compreendidas') ?? [];
    if (!lista.contains(widget.palavra)) {
      lista.add(widget.palavra);
      await widget.prefs.setStringList('palavras_compreendidas', lista);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (erro || dados == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.palavra)),
        body: const Center(child: Text("Erro ao carregar definição.")),
      );
    }

    final meanings = dados!['meanings'] as List<dynamic>;
    final phonetics = dados!['phonetics'] as List<dynamic>;

    String? audioUrl;
    for (var p in phonetics) {
      if (p['audio'] != null && p['audio'] != "") {
        audioUrl = p['audio'];
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.palavra)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (audioUrl != null)
              ElevatedButton(
                onPressed: () => player.play(UrlSource(audioUrl!)),
                child: const Text("Tocar Áudio"),
              ),
            const SizedBox(height: 20),
            ...meanings.map((m) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['partOfSpeech'] ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  ...((m['definitions'] as List).map((d) {
                    return Text("• ${d['definition']}");
                  })),
                  const SizedBox(height: 15),
                ],
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _marcarCompreendido,
              child: const Text("Marcar como compreendida"),
            )
          ],
        ),
      ),
    );
  }
}

class TelaPalavras extends StatefulWidget {
  final SharedPreferences prefs;
  const TelaPalavras({required this.prefs, super.key});

  @override
  State<TelaPalavras> createState() => _TelaPalavrasState();
}

class _TelaPalavrasState extends State<TelaPalavras> {
  List<String> palavras = [];

  @override
  void initState() {
    super.initState();
    palavras = widget.prefs.getStringList('palavras_compreendidas') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Palavras Compreendidas")),
      body: ListView.builder(
        itemCount: palavras.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(palavras[i]),
          );
        },
      ),
    );
  }
}
