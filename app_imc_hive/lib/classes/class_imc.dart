
// Criando uma class imc para armazenar os dados do imc.
class Imc {
  double? peso;
  double? altura;
  String? resultado;

  Imc({this.peso, this.altura, this.resultado});

  factory Imc.fromJson(Map<String, dynamic> json) {
    return Imc(
      peso: json['peso'],
      altura: json['altura'],
      resultado: json['resultado'],
    );
  }
}

