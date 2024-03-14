import 'package:flutter/material.dart';
import '../_commons/my_colors.dart';
import '../service/authenticator_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela inicial"),
        backgroundColor: MyColors.azulEscuro,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              onTap: () {
                AuthenticatorService().deslogar();
              },
            )
          ],
        ),
      ),
    );
  }
}
