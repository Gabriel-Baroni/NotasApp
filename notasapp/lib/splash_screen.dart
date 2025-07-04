// Importações necessárias
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------TELA SPLASH----------------
class SplashScreen extends StatefulWidget { //Criação da classe SplashScreen como StatefulWidget, pois possui a barra de carregamento
  const SplashScreen(); //Identificação da classe na arvore de elementos 

  @override
  _SplashScreenState createState() => _SplashScreenState(); //Cria um estado para os elementos variáveis da SplashScreen (_progress). 
}

class _SplashScreenState extends State<SplashScreen> { // Cria um estado para mudar o conteúdo da variável _progress
  double _progress = 0; // Declara a variável que será usada na barra de carregamento

  @override
  void initState() { // Permite a mudança de variáveis no estado da classe
    super.initState();

    // Carregamento da barra com a variável _progress
    Timer.periodic(Duration(milliseconds: 200), (timer) { 
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()), // Redireciona para a tela principal 
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem Vindo ao Notas bacanas',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hora de tomar várias notas!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 24),
            Image.asset('images/bloco.png', fit: BoxFit.cover, height: 50),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.lightGreenAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------TELA PRINCIPAL----------------
class HomeScreen extends StatelessWidget { //Crindo a classe HomeScreen Stateless
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Notas'),
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder<QuerySnapshot>( // Fazendo a consulta no Firebase, na coleção: Notas e ordenando por data decrescente
        stream: FirebaseFirestore.instance 
            .collection('notas')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          //CONDIÇÕES PARA A CONEXÃO
          if (snapshot.connectionState == ConnectionState.waiting) { // Se estiver em estado de espera, mostrar circulo de carregamento
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) { // Se estiver sem notas ou estiverem vazias, retorna o texto.
            return Center(child: Text('Nenhuma nota ainda.'));
          }

          final notas = snapshot.data!.docs; //Atribuindo à variável notas o valor da consulta no Firebase e verificando se ela não é nula.

          return ListView.builder(
            itemCount: notas.length, //Determina o número da lista a ser construída com o tamanho da variável notas
            itemBuilder: (context, index) { 
              final nota = notas[index]; // Pega a posição do item
              final titulo = nota['titulo'] ?? 'Sem título'; // Pega o título ou então mostra que não tem
              final conteudo = nota['conteudo'] ?? ''; // pega o conteúdo ou então mostra que não tem 

              return ListTile(
                title: Text(titulo),
                subtitle: Text(
                  conteudo.length > 50
                      ? '${conteudo.substring(0, 50)}...'
                      : conteudo,
                ),
                onTap: () {
                  Navigator.push( //Redireciona o usuário para a tela NotaDetalhePage
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotaDetalhePage(
                        //Envia esses dados para a próxima tela
                        notaId: nota.id,
                        titulo: titulo,
                        conteudo: conteudo,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push( //Redireciona o usuário para a tela NotaDetalhePage 
            context,
            MaterialPageRoute(
              builder: (_) => NotaDetalhePage(), 
            ),
          );
        },
      ),
    );
  }
}

// ------------TELA DETALHE DA NOTA----------------
class NotaDetalhePage extends StatefulWidget { //Cria a Classe NotaDetalhePage Stateful, pois usa dados da consulta ao Firebase
// Criando as variáveis que podem ser nulas 
  final String? notaId;
  final String? titulo;
  final String? conteudo;

  const NotaDetalhePage({this.notaId, this.titulo, this.conteudo}); // Atribuindo os dados passados pela classe HomeScreen as variáveis criadas
 
  @override
  _NotaDetalhePageState createState() => _NotaDetalhePageState(); //Criando um estado para a classe NotaDetalhePage
}

class _NotaDetalhePageState extends State<NotaDetalhePage> {
  final _tituloController = TextEditingController(); // Permite armazenar o que o usuário escreve no textfiled
  final _conteudoController = TextEditingController(); // Permite armazenar o que o usuário escreve no textfiled

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.titulo ?? ''; // Atribuindo o valor do titulo ao texto do controlador, ou nulo 
    _conteudoController.text = widget.conteudo ?? ''; // Atribuindo o valor do conteudo ao texto do controlador, ou nulo
  }

  void salvarNota() async { // Função assíncrona para salvar as notas
    final titulo = _tituloController.text; //Atribui a variavel o titulo 
    final conteudo = _conteudoController.text; //Atribui a variavel o conteudo 

    if (titulo.isEmpty || conteudo.isEmpty) return; //Se algum deles for nulo, não continua o código

    final notas = FirebaseFirestore.instance.collection('notas'); //Faz uma consulta a coleção notas do Firebase

    if (widget.notaId == null) { 
    //Adiciona a nota a lista de notas
      await notas.add({
        'titulo': titulo,
        'conteudo': conteudo,
        'data': DateTime.now(),
      });
    } else {
      //Atualiza a referida nota com base no id
      await notas.doc(widget.notaId).update({
        'titulo': titulo,
        'conteudo': conteudo,
        'data': DateTime.now(),
      });
    }

    Navigator.pop(context); // Retorna para a tela principal
  }

  void deletarNota() async { // Função para deletar as notas
    if (widget.notaId != null) {
      await FirebaseFirestore.instance 
          .collection('notas')
          .doc(widget.notaId)
          .delete();
    }
    Navigator.pop(context); // Retorna para a tela principal
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.notaId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Nota' : 'Nova Nota'),
        backgroundColor: Colors.greenAccent,
        actions: editando
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deletarNota,
                )
              ]
            : [],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextField(
                controller: _conteudoController,
                decoration: InputDecoration(labelText: 'Conteúdo'),
                maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: salvarNota,
        backgroundColor: Colors.green,
        child: Icon(Icons.save),
      ),
    );
  }
}
