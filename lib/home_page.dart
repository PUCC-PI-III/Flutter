import 'package:flutter/material.dart';
import 'relatorios_page.dart';
import 'riscos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nome app',
          style: TextStyle(color: Color(0xFFFFBB00)),
        ),
        backgroundColor: Colors.black,
        leading: const Icon(Icons.arrow_back, color: Color(0xFFFFBB00)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RiscosPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFBB00),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Consultar riscos identificados',
               style: TextStyle(color: Colors.black,  fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RelatoriosPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFBB00),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Consultar relatórios',
                style: TextStyle(color: Colors.black,  fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
