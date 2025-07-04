// Importações necessárias
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

// Inicia o aplicativo com função assíncrona aguardando a conexão com o firebase
Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //Pegando as configurações do arquivo firebase_options.dart
  runApp(const MyApp()); //Instanciando a classe Myapp
}

// Criação da classe Myapp, essa classe chama a tela SplashScreen
class MyApp extends StatelessWidget { //Class StateLess, pois é constante após a criação
  const MyApp();

  @override // Sobreescreve o método build: 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Tirando a faixa de debug
      title: "Meu app", // Nomeando o app
      theme: ThemeData(primarySwatch: Colors.green), //Tema principal do app
      home: SplashScreen(), // Chamando/redirecionando para a SplashScreen 
    );
  }
}
