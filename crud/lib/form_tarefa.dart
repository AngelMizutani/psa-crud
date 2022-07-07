import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FormTarefa extends StatelessWidget {
  String? nome;
  String? descricao;

  salvar(String nome, String descricao, [int? id]) async {
    var caminho = join(await getDatabasesPath(), 'banco.db');
    Database banco = await openDatabase(caminho);
    String sql;

    if (id == null) {
      sql = 'INSERT INTO tarefa(nome, descricao) VALUES (?,?)';
      banco.rawInsert(sql, [nome, descricao]);
    } else {
      sql = 'UPDATE tarefa SET nome = ?, descricao = ? WHERE id = ?';
      banco.rawUpdate(sql, [nome, descricao, id]);
    }
  }

  Widget criarTextField(String label, String hintText, ValueChanged onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(label: Text(label), hintText: hintText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tarefas'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              criarTextField('Nome', 'Escreva um título para a tarefa',
                  (value) => nome = value),
              criarTextField('Descrição', 'Escreva a descrição da sua tarefa',
                  (value) => descricao = value),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  salvar(nome!, descricao!);
                  Navigator.pushNamed(context, '/');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
