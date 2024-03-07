import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AppImc extends StatefulWidget {
  const AppImc({Key? key}) : super(key: key);

  @override
  State<AppImc> createState() => _AppImcState();
}

class _AppImcState extends State<AppImc> {
  double? _peso;
  double? _altura;
  String? _resultado;
  late Box _imcBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  void _initHive() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    _imcBox = await Hive.openBox('imcBox');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 50, 195, 55),
        centerTitle: true,
        leading: const Icon(
          Icons.calculate,
          color: Colors.black,
          size: 35,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (value) {
                  _peso = double.tryParse(value);
                },
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$')),
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (value) {
                  _altura = double.tryParse(value);
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (_altura != null && _peso != null) {
                      setState(() {
                        _resultado = _calcularImc(_peso!, _altura!);
                        _imcBox.put('imc', _resultado);
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'Erro',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          icon: const Icon(Icons.error_outline, color: Colors.red),
                          content: const Text(
                            'Por favor, insira os dados corretamente.',
                            style: TextStyle(color: Colors.black87, fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                          elevation: 24,
                          backgroundColor: Colors.white,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Ok',
                                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: const BorderSide(color: Colors.green),
                    ),
                    backgroundColor: const Color.fromARGB(255, 50, 195, 55),
                  ),
                  child: const Text(
                    'Calcular',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (_resultado != null) const SizedBox(height: 20),
              if (_resultado != null)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Seu IMC é de: $_resultado',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (_resultado != null)
                      Text(
                        'Sua classificação é: ${_classificarImc(double.parse(_resultado!))}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _calcularImc(double peso, double altura) {
  double imc = peso / (altura * altura);
  return imc.toStringAsFixed(1);
}

String _classificarImc(double imc) {
  if (imc < 18.5) {
    return 'Abaixo do peso';
  } else if (imc >= 18.5 && imc < 24.9) {
    return 'Peso normal';
  } else if (imc >= 24.9 && imc < 29.9) {
    return 'Acima do peso';
  } else if (imc >= 29.9 && imc < 34.9) {
    return 'Obeso';
  } else if (imc >= 34.9 && imc < 39.9) {
    return 'Obeso Severo';
  }
  return 'Obeso Mórbido';
}
