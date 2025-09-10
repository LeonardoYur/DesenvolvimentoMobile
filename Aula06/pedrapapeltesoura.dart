import 'package:flutter/material.dart';

void main() {
  runApp(NovoWidgetEstado());
}

class NovoWidgetEstado extends StatefulWidget {
  const NovoWidgetEstado({super.key});

  @override
  State<NovoWidgetEstado> createState() => _NovoWidgetEstadoState();
}

class _NovoWidgetEstadoState extends State<NovoWidgetEstado> {
  var i = 0;
  var imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg',
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG',
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg'
  ];

  // hot reload executa build()
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: Container(width: 200, child: Image.network(imagens[i])),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    if (i == 2) i = 0;
                    i++;
                  });
                },
                child: const Text('Próximo')),
          ],
        ),
      ),
    );
  }
}
