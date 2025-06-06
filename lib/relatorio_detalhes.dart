import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Relatorio {
  final String titulo;
  final String? obs;
  final DateTime data;

  Relatorio({required this.titulo, this.obs, required this.data});
}

class RelatoriosDetalhesPage extends StatefulWidget {
  const RelatoriosDetalhesPage({super.key});

  @override
  State<RelatoriosDetalhesPage> createState() => _RelatoriosDetalheState();
}

class _RelatoriosDetalheState extends State<RelatoriosDetalhesPage> {
  List<Relatorio> _relatorios = [];

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  Future<void> buscarDados() async {
    final url = Uri.parse("http://127.0.0.1:8080/relatorio");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Relatorio> novosRelatorios = [];

        for (var item in jsonList) {
          final titulo = item['tit'] ?? 'Sem título';
          final obs = item['obs'];
          final dataHora = item['date'] != null
              ? DateTime.parse(item['date'])
              : DateTime.now();

          novosRelatorios.add(
            Relatorio(titulo: titulo, obs: obs, data: dataHora),
          );
        }

        setState(() {
          _relatorios = novosRelatorios;
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  String _formatarDataHora(DateTime data) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}  '
           '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }

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
      body: ListView.builder(
        itemCount: _relatorios.length,
        itemBuilder: (context, index) {
          final relatorio = _relatorios[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Color(0xFFFFBB00)),
              title: Text(
                relatorio.titulo,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data: ${_formatarDataHora(relatorio.data)}',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  if (relatorio.obs != null && relatorio.obs!.isNotEmpty)
                    Text(
                      'Obs: ${relatorio.obs}',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
