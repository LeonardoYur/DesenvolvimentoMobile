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
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Página A'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Primeira'),
            SizedBox(height: 50),
            Image.network(
              'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
            ),
            ElevatedButton(
              onPressed: () {
                // código para ir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SegundaPagina(),
                  ),
                );
              },
              child: const Text('Próxima'),
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaPagina extends StatelessWidget {
  const SegundaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Página B'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Segunda'),
            SizedBox(height: 50),
            Image.network(
              'https://static.wixstatic.com/media/6d1e48_1789d9211df04b428974e987bcb79662~mv2.png/v1/fill/w_280,h_280,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/Design%20sem%20nome%20(22).png',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
