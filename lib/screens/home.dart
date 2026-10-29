import 'package:flutter/material.dart';
import 'package:parking_spot/controllers/parking_spot_controller.dart';
import 'package:parking_spot/models/parking_spot_model.dart';
import 'package:parking_spot/screens/parking_spot_form.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ParkingSpotController _controller = ParkingSpotController();
  late Future<List<ParkingSpot>> _futureSpots;

  @override
  void initState() {
    super.initState();
    _futureSpots = _controller.getAll();
  }

  void _reload() {
    setState(() {
      _futureSpots = _controller.getAll();
    });
  }

  Future<void> _openForm() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const ParkingSpotFormPage()),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(ParkingSpot spot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir vaga'),
        content: Text(
          'Deseja excluir a vaga ${spot.parkingSpotNumber} '
              '(placa ${spot.licensePlateCar})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _controller.delete(spot.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vaga excluída.')),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Recarregar',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<ParkingSpot>>(
        future: _futureSpots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final spots = snapshot.data ?? [];
          if (spots.isEmpty) {
            return const Center(child: Text('Nenhuma vaga cadastrada.'));
          }
          return ListView.builder(
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(child: Text(spot.parkingSpotNumber)),
                  title: Text('${spot.brandCar} ${spot.modelCar} - ${spot.colorCar}'),
                  subtitle: Text(
                    'Placa: ${spot.licensePlateCar}\n'
                        '${spot.responsibleName} - Apto ${spot.apartment}, Bloco ${spot.block}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () => _confirmDelete(spot),
                    tooltip: 'Excluir vaga',
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        tooltip: 'Cadastrar vaga',
        child: const Icon(Icons.add),
      ),
    );
  }
}