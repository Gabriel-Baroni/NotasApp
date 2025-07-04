# notasapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# DESCRIÇÃO CRIADA PELOS ALUNOS

# O que foi usado que não foi ensinado: 
- Exclusão de dados (splash_screen.dart: linha 208)
- Update de dados (splash_screen.dart: linha 193)
- Inserir dados (splash_creen.dart: linha 186)
- Textfield e controladores de texto
- Timer.periodic (splash_screen.dart: linha 22)
- Barras de carregamento (splash_screen.dart: linhas 62 e 95)
 
# Explicação da estrutura do app
Aplicativo para criação de notas de texto. Com as funcionalidades de edição da nota e exclusão. A estrutura do aplicativo é feita a partir da pasta lib, com 3 arquivos: firebase_options.dart, main.dart, splash_screen.dart. O primeiro arquivo é criado com a configuração do firebase, os outros dois são referentes a telas. 
No main.dart é criada a class MyApp chama a tela SplashScreen(), no arquivo splash_screen.dart é criada as três telas a partir de classes: Splash_screen, HomeScreen e NotaDetalhePage. A única Stateless é a HomeScreen, as outras são Stateful por possuírem variáveis mutaveis.  



Ao executar o aplicativo o usuário verá a tela de carregamento(SplashScreen) e a barra de carregamento irá se atualizar. Após a tela de carregamento o usuário estará na tela principal do app, onde ele pode ver as notas ja criadas ou clicar no botão no canto inferior direito para criar uma nova nota.