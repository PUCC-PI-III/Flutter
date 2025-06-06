import 'package:appadm/relatorio_mensal.dart';
import 'package:appadm/relatorio_semanal.dart';
import 'package:flutter/material.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nome app',
          style: TextStyle(color: Color(0xFFFFBB00)),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFBB00)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.description, color: Colors.yellow),
              title: const Text(
                "Relatório semanal",
                style: TextStyle(color: Color(0xFFFFBB00)),
              ),
              trailing: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RelatoriosSemanalPage()),
                ),
                child: const Text(
                  'Abrir',
                  style: TextStyle(color: Color(0xFFFFBB00)),
                ),
              ),
            ),
          ),
          Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.description, color: Colors.yellow),
              title: const Text(
                "Relatório mensal",
                style: TextStyle(color: Color(0xFFFFBB00)),
              ),
              trailing: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RelatoriosMensalPage()),
                ),
                child: const Text(
                  'Abrir',
                  style: TextStyle(color: Color(0xFFFFBB00)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
