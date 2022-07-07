import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaTarefa extends StatelessWidget {
  Future<List<Map<String, Object?>>> buscarDados() async {
    await Future.delayed(const Duration(seconds: 2));
    List<Map<String, Object?>> tarefas = [
      {'nome': 'Projeto', 'descricao': 'Projeto WEB'},
      {'nome': 'Apresentacao', 'descricao': 'Apresentacao Grupo'},
      {'nome': 'Lista', 'descricao': 'Lista de Exercicios'}
    ];

    return tarefas;

    // List<Map<String, Object?>> dados = [
    //   {'nome': 'José', 'sobrenome': 'Silva', 'idade': 8}
    // ];
    // print(dados.length);
    // print(dados.keys);
    // print(dados.values);
    // print(dados['nome']);
  }

  Future<List<Map<String, Object?>>> buscarDadosBanco() async {
    String caminhoBD = join(await getDatabasesPath(), 'banco.db');

    Database banco = await openDatabase(
      caminhoBD,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
          CREATE TABLE tarefa(
            id INTEGER PRIMARY KEY
            , nome TEXT NOT NULL
            , descricao TEXT NOT NULL
          )
        ''');
        //   db.execute(
        //       'INSERT INTO tarefa (nome, descricao) VALUES ("Ursinho", "terminar ursinho de feltro")');
        //   db.execute(
        //       'INSERT INTO tarefa (nome, descricao) VALUES ("Pulseira", "fazer pulseira de miçanga")');
        //   db.execute(
        //       'INSERT INTO tarefa (nome, descricao) VALUES ("Artigo", "terminar artigo")');
      },
    );
    List<Map<String, Object?>> tarefas =
        await banco.rawQuery('SELECT * FROM tarefa');
    return tarefas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/formTarefa'),
          )
        ],
      ),
      body: FutureBuilder(
        future: buscarDadosBanco(),
        builder:
            (context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturos) {
          if (!dadosFuturos.hasData) {
            return const CircularProgressIndicator();
          }
          var tarefas = dadosFuturos.data!;
          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, contador) {
              var tarefa = tarefas[contador];
              return ListTile(
                title: Text(tarefa['nome'].toString()),
                subtitle: Text(tarefa['descricao'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
