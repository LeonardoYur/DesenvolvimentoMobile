import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: PrimeiraPagina()),
  );
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Sobre Mim'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'João Silva',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('25 anos', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilmesPagina(),
                  ),
                );
              },
              child: const Text('Filmes', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LivrosPagina(),
                  ),
                );
              },
              child: const Text('Livros', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class FilmesPagina extends StatelessWidget {
  const FilmesPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final filmes = [
      'O Senhor dos Anéis',
      'Star Wars',
      'Matrix',
      'Interestelar',
      'Vingadores'
    ];

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Meus Filmes Favoritos'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: filmes.length + 1,
        itemBuilder: (context, index) {
          if (index < filmes.length) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(15),
              color: Colors.amber,
              child: Text(
                '${index + 1}. ${filmes[index]}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar', style: TextStyle(color: Colors.black)),
              ),
            );
          }
        },
      ),
    );
  }
}

class LivrosPagina extends StatelessWidget {
  const LivrosPagina({super.key});

  @override
  Widget build(BuildContext context) {
    final livros = [
      'Dom Quixote',
      '1984',
      'O Hobbit',
    ];

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Meus Livros Favoritos'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: livros.length + 1,
        itemBuilder: (context, index) {
          if (index < livros.length) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(15),
              color: Colors.amber,
              child: Text(
                '${index + 1}. ${livros[index]}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar', style: TextStyle(color: Colors.black)),
              ),
            );
          }
        },
      ),
    );
  }
}
