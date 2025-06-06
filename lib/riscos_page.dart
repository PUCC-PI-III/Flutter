import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RiscosPage extends StatefulWidget {
  const RiscosPage({super.key});

  @override
  State<RiscosPage> createState() => _RiscosPageState();
}

class _RiscosPageState extends State<RiscosPage> {
  static const LatLng _googlePlex = LatLng(-22.8330763, -47.0552194);
  Set<Marker> _marcadores = {};

  @override
  void initState() {
    super.initState();
    buscarLocalizacoes();
  }

  Future<void> concluirRisco(String id, BuildContext context) async {
  final url = Uri.parse("http://127.0.0.1:8080/atualiza");

  try {
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"_id": id}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Risco finalizado!")),
      );
      Navigator.pop(context);
  await buscarLocalizacoes();
    } else {
      print('Erro ao atualizar: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro na requisição: $e');
  }
}


  Future<void> buscarLocalizacoes() async {
    final url = Uri.parse("http://127.0.0.1:8080/riscos");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        Set<Marker> novos = {};

        for (var i = 0; i < jsonList.length; i++) {
          final item = jsonList[i];
          final localStr = item['localizacao'];

          if (localStr != null && localStr is String && item['status'] == false) {
            final partes = localStr.split(',');

            if (partes.length >= 2) {
              final lat = double.tryParse(partes[0]);
              final lng = double.tryParse(partes[1]);

              if (lat != null && lng != null) {
                BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

                novos.add(
                  Marker(
                    markerId: MarkerId('marker_$i'),
                    position: LatLng(lat, lng),
                    icon: icon,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            backgroundColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['tit'] ?? 'Sem título',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (item['imagem'] != null)
                                      Image.memory(
                                        base64Decode(item['imagem']),
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    const SizedBox(height: 12),
                                    if (item['obs'] != null)
                                      Text(
                                        'Obs: ${item['obs']}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ElevatedButton(

                                      onPressed: () => concluirRisco(item['_id'], context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF5CB85C),
                                        
                                      ),
                                      child: const Text(
                                        'Concluir',
                                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            }
          }
        }

        setState(() {
          _marcadores = novos;
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _googlePlex,
                  zoom: 13,
                ),
                markers: _marcadores,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
