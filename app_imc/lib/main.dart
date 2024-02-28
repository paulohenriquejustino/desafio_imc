import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Inicador da aplicação
void main() {
  runApp(const MaterialApp(
    // Removendo o banner de debug
    debugShowCheckedModeBanner: false,
    // Tela inicial
    home: AppImc(),
  ));
}

// classe principal 
class AppImc extends StatefulWidget {
  // Construtor
  const AppImc({Key? key}) : super(key: key);

  // responsável pelo estado da classe AppImc.
  @override
  State<AppImc> createState() => _AppImcState();
}

// Função que calcula o IMC
String? _calcularImc(double peso, double altura) {
  // Calculando o IMC
  double imc = peso / (altura * altura);
  // Formatando o resultado, utilizando o toStringAsFixed(1) que faz a formatação de 1 dígito decimal.
  return imc.toStringAsFixed(1);
}

// Função que classifica o IMC
String _classificarImc(double imc) {
  // se o IMC for menor que 18.5..
  if (imc < 18.5) {
    return 'Abaixo do peso';
    // e se o IMC for maior que 18.5 e menor que 24.9...
  } else if (imc >= 18.5 && imc < 24.9) {
    return 'Peso normal';
  } else if (imc >= 24.9 && imc < 29.9) {
    return 'Acima do peso';
  } else if (imc >= 29.9 && imc < 34.9) {
    return 'Obeso';
  } else if (imc >= 34.9 && imc < 39.9) {
    return 'Obeso Severo';
  }
  // e se o IMC for maior ou igual a 40
  return 'Obeso Mórbido';
}

// Classe responsável pelo estado da classe AppImc.
class _AppImcState extends State<AppImc> {
  // Variáveis
  double? _peso;
  double? _altura;
  String? _resultado;

  @override
  Widget build(BuildContext context) {
    // Scaffold responsável pelo corpo da tela.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      // AppBar responsável pelo topo da tela.
      appBar: AppBar(
        // Titulo do app
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        // Cor de fundo
        backgroundColor: const Color.fromARGB(255, 50, 195, 55),
        // Alinhamento do texto
        centerTitle: true,
        // Icone
        leading: const Icon(
          Icons.calculate,
          color: Colors.black,
          size: 35,
        ),
      ),
      // Adicinando um SingleChildScrollView responsável para permitir a rolação da tela.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField responsável pelo campo de entrada de dados
              TextField(
                // Decorando o campo de entrada
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                // Definindo o tipo de teclado
                keyboardType: TextInputType.number,
                // Definindo os filtros de dígitos.
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                // Definindo o valor do campo de entrada de dados
                onChanged: (value) {
                  // Convertendo o valor de string para double
                  _peso = double.tryParse(value);
                },
              ),
              const SizedBox(height: 30),
              // TextField responsável pelo campo de entrada de dados
              TextField(
                // Decorando o campo de entrada
                decoration: const InputDecoration(
                  labelText: 'Altura (m)',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                // Definindo o tipo de teclado
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Definindo os filtros de dígitos.
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}$')),
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                // Definindo o valor do campo de entrada de dados
                onChanged: (value) {
                  // Convertendo o valor de string para double
                  _altura = double.tryParse(value);
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                // Criando o botão para calcular o IMC.
                child: ElevatedButton(
                  // ao ser pressionado, chama a função _calcularImc.
                  onPressed: () {
                    // se a altura for difenrente de null e o peso for diferente de null...
                    if (_altura != null && _peso != null) {
                      // entao chama a função _calcularImc e atualiza o estado.
                      setState(() {
                        _resultado = _calcularImc(_peso!, _altura!);
                      });
                      // senão, mostra uma mensagem de erro.
                    } else {
                      // mostra uma mensagem de erro, com o alerta do ShowDialog.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          // Definindo o alerta.
                          title: const Text(
                            'Erro',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          icon: const Icon(Icons.error_outline, color: Colors.red),
                          // Definindo o conteudo do alerta.
                          content: const Text(
                            'Por favor, insira os dados corretamente.',
                            style: TextStyle(color: Colors.black87, fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                          elevation: 24,
                          backgroundColor: Colors.white,
                          // Definindo os botoes do alerta.
                          actions: [
                            // Botão para fechar o alerta.
                            TextButton(
                              // Utilizando na propriedade onPressed do botão o 
                              //navigator.pop(context) para fechar o alerta.
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
                  // Definindo o estilo do botão.
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                    // Utilizando o shape para definir as bordas do botão.
                    shape: RoundedRectangleBorder(
                      // Definindo o raio do botão e a formatação da borda.
                      borderRadius: BorderRadius.circular(32),
                      // Definindo a cor da borda.
                      side: const BorderSide(color: Colors.green),
                    ),
                    // Definindo a cor de fundo do botão.
                    backgroundColor: const Color.fromARGB(255, 50, 195, 55),
                  ),
                  // Definindo o texto do botão.
                  child: const Text(
                    'Calcular',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Verificando se o resultado é diferente de null e mostrando o resultado.
              if (_resultado != null)
                const SizedBox(height: 20),
                // Criando a coluna para mostrar o resultado.
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Seu IMC é de: $_resultado',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    // Verificando se o resultado é diferente de null e mostrando a classificação.
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
