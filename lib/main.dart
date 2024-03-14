import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meus_gastos/view/authentication_view.dart';
import 'package:meus_gastos/view/home_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //falando para o flutter que só pode iniciar apos executar o firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RouterView(),
    );
  }
}

class RouterView extends StatelessWidget {
  const RouterView({super.key});

  //verifica se houve alteracao no estado do usuario
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        //se chegar algo significa se o user esta logado
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const AuthenticationView();
        }
      },
    );
  }
}