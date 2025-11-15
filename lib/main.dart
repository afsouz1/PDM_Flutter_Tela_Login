import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController cLogin = TextEditingController();
  TextEditingController cSenha = TextEditingController();

  late String login, senha;

  void _incrementCounter() {
    setState(() {
      login = cLogin.text;
      senha = cSenha.text;
      enviar_requisicao(login, senha);

    });
  }

  Future<void> enviar_requisicao(String login, String senha) async {
    var client = http.Client();
    try {
      Map<String,String> headers = {'Content-Type':'application/json' };
      final msg = jsonEncode( {'email': login, 'password': senha});

      var response = await client.post(
        Uri.https('linuxjf.com', '/apij/auth/login'),
        headers: headers,
        body: msg,
      );


      print('resposta: $response \n');

      if(response.statusCode==200) { // 200 -
        var jsonresposta = jsonDecode(
            utf8.decode(response.bodyBytes)) as Map;
        _showAlertDialog(context, "Login realizado com sucesso.");
      } else{
        _showAlertDialog(context, "Falha ao realizar login.");
      }


    }  catch (e) {
      _showAlertDialog(context, "Erro ao realizar login: $e");
    } finally {
      client.close(); // apenas fecha a conexão
    }


  }


  void _showAlertDialog(BuildContext context, String texto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login usuário'),
          content: Text(texto),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
          child: Container(width: 350,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
            // const Text('Username'),
            TextField(
            controller: cLogin,
            decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person),
                // suffixIcon: Icon(Icons.check_circle),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
          ),
          SizedBox(height: 30,),
          //const Text('Password'),
          TextField(
            controller: cSenha,
            decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                // suffixIcon: Icon(Icons.check_circle),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
            obscureText: true,
          ),
          SizedBox(height: 25,),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  )
              ),
            ),
          ),
      ]),
    ),
    ),
    );

  }
}
