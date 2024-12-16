import 'package:edywasacliente/Cores/cores.dart';
import 'package:flutter/material.dart';

// Definindo a cor azul que você está usando
ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(12), // Espaçamento interno
    backgroundColor: azul, // Cor de fundo
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50), // Bordas arredondadas
    ),
     minimumSize: const Size(150, 40),
     textStyle: const TextStyle(
      fontSize: 16, // Tamanho da fonte
      fontWeight: FontWeight.bold, // Peso da fonte
      color: Colors.white, // Cor do texto
    ),
  );
}
