import 'package:flutter/material.dart';
import 'package:parking_spot/controllers/parking_spot_controller.dart';
import 'package:parking_spot/models/parking_spot_model.dart';

class ParkingSpotFormPage extends StatefulWidget {
  const ParkingSpotFormPage({super.key});

  @override
  State<ParkingSpotFormPage> createState() => _ParkingSpotFormPageState();
}

class _ParkingSpotFormPageState extends State<ParkingSpotFormPage> {
  final ParkingSpotController _controller = ParkingSpotController();
  final _formKey = GlobalKey<FormState>();

  final _spotNumber = TextEditingController();
  final _plate = TextEditingController();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _color = TextEditingController();
  final _responsible = TextEditingController();
  final _apartment = TextEditingController();
  final _block = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _spotNumber.dispose();
    _plate.dispose();
    _brand.dispose();
    _model.dispose();
    _color.dispose();
    _responsible.dispose();
    _apartment.dispose();
    _block.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      // id e registrationDate são provisórios: o backend gera os reais
      // e o toJson() não os envia.
      final spot = ParkingSpot(
        '',
        _spotNumber.text.trim(),
        _plate.text.trim(),
        _brand.text.trim(),
        _model.text.trim(),
        _color.text.trim(),
        DateTime.now(),
        _responsible.text.trim(),
        _apartment.text.trim(),
        _block.text.trim(),
      );
      await _controller.create(spot);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório';
    return null;
  }

  Widget _field(
      String label,
      TextEditingController controller, {
        int? maxLength,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        validator: _required,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cadastrar vaga'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field('Número da vaga', _spotNumber, maxLength: 10),
              _field('Placa', _plate, maxLength: 7),
              _field('Marca', _brand),
              _field('Modelo', _model),
              _field('Cor', _color),
              _field('Responsável', _responsible),
              _field('Apartamento', _apartment),
              _field('Bloco', _block),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}