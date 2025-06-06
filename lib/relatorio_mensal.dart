import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Risco {
  final String titulo;
  final String? obs;
  final DateTime data;
  final String status;
  Risco({
    required this.titulo,
    this.obs,
    required this.data,
    required this.status,
  });
}

class SemanaComRiscos {
  final String semana;
  final List<Risco> riscos;

  SemanaComRiscos({required this.semana, required this.riscos});
}

class RelatoriosMensalPage extends StatefulWidget {
  const RelatoriosMensalPage({super.key});

  @override
  State<RelatoriosMensalPage> createState() => _RelatoriosMensalPageState();
}

class _RelatoriosMensalPageState extends State<RelatoriosMensalPage> {
  List<SemanaComRiscos> _dados = [];

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  Future<void> buscarDados() async {
    final url = Uri.parse("http://127.0.0.1:8080/relatoriomensal");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<SemanaComRiscos> resultado = [];

        for (var grupo in jsonList) {
          final semana = grupo['week'] ?? 'Semana desconhecida';
          final List<Risco> riscos = [];

          for (var item in grupo['riscos']) {
            final titulo = item['tit'] ?? 'Sem título';
            final obs = item['obs'];
            final data = item['date'] != null
                ? DateTime.parse(item['date'])
                : DateTime.now();
            final status = (item['status'] == false) ? "Em aberto" : "Finalizado";

            riscos.add(Risco(titulo: titulo, obs: obs, data: data, status: status));
          }

          resultado.add(SemanaComRiscos(semana: semana, riscos: riscos));
        }

        setState(() {
          _dados = resultado;
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
    return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}';
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
        itemCount: _dados.length,
        itemBuilder: (context, index) {
          final grupo = _dados[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da semana
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Semana: ${grupo.semana}',
                  style: const TextStyle(
                    color: Color(0xFFFFBB00),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Lista de riscos dessa semana
              ...grupo.riscos.map(
                (risco) => Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: Color(0xFFFFBB00),
                    ),
                    title: Text(
                      risco.titulo,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: ${risco.status}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Data: ${_formatarDataHora(risco.data)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        if (risco.obs != null && risco.obs!.isNotEmpty)
                          Text(
                            'Obs: ${risco.obs}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
