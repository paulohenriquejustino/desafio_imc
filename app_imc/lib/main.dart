import 'package:app_imc/classes/imc_class.dart';
import 'package:app_imc/config_hive.dart';
import 'package:flutter/material.dart';


// Inicializador da aplicação
void main() async {
  // Garante que o widget Flutter seja inicializado.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando o Hive.
  await  HiveConfig.start();
  runApp(const MaterialApp(
    // Removendo o banner de debug
    debugShowCheckedModeBanner: false,
    // Tela inicial
    home: AppImc(),
  ));
}


