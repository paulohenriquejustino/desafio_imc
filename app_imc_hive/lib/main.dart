import 'package:app_imc/meu_app.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


// Inicializador da aplicação
void main() async {
  // Garante que o widget Flutter seja inicializado.
  WidgetsFlutterBinding.ensureInitialized();
  // Obtem o diretório de arquivos do aplicativo.
  var documentosDiretorio = await path_provider.getApplicationDocumentsDirectory();

  // Inicializando o Hive.
  // O arquivo de configuração do Hive fica dentro do diretório de arquivos do aplicativo.
  Hive.init(documentosDiretorio.path);
  runApp(const MaterialApp(
    // Removendo o banner de debug
    debugShowCheckedModeBanner: false,
    // Tela inicial
    home: CalculadoraImcHive(),
  ));
}


