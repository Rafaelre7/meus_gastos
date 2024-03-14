import 'package:flutter/material.dart';

import '../_commons/my_colors.dart';
import '../_commons/my_snackbar.dart';
import '../component/decoration_field_authentication.dart';
import '../service/authenticator_service.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

//estancias dos objetos para controlar os textInformField
TextEditingController _emailController = TextEditingController();
TextEditingController _senhaController = TextEditingController();
TextEditingController _nomeController = TextEditingController();

AuthenticatorService _authenticatorService = AuthenticatorService();

class _AuthenticationViewState extends State<AuthenticationView> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        //coloca um elemento acima do outro
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      MyColors.azulTopoGradiente,
                      MyColors.azulBaixoGradiente
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, //informar para o form que temos um validate
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset("assets/logo.png", height: 128),
                      const Text(
                        "Meus Gastos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getAutheticationIputDecoration("E-mail"),
                        validator: (String? value) {
                          //para dar ok retornar null
                          if (value == null) {
                            return "O e-mail não pode ser vazio";
                          }
                          if (value.length < 5) {
                            return "O e-mail é muito curto";
                          }
                          if (!value.contains("@")) {
                            return "O e-mail não é valido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getAutheticationIputDecoration("Senha"),
                        obscureText: true,
                        validator: (String? value) {
                          //para dar ok retornar null
                          if (value == null) {
                            return "A senha não pode ser vazia";
                          }
                          if (value.length < 5) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                          visible: !queroEntrar,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: getAutheticationIputDecoration(
                                    "Confirme a Senha"),
                                obscureText: true,
                                validator: (String? value) {
                                  //para dar ok retornar null
                                  if (value == null) {
                                    return "A confirmação de senha não pode ser vazia";
                                  }
                                  if (value.length < 5) {
                                    return "A confirmação de senha é muito curta";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nomeController,
                                decoration:
                                getAutheticationIputDecoration("Nome"),
                                validator: (String? value) {
                                  //para dar ok retornar null
                                  if (value == null) {
                                    return "O nome não pode ser vazio";
                                  }
                                  if (value.length < 5) {
                                    return "O nome é muito curto";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          botaoPrincipalClicado();
                        },
                        child: Text((queroEntrar) ? "Entrar" : "Cadastrar"),
                      ),
                      const Divider(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            queroEntrar = !queroEntrar;
                          });
                        },
                        child: Text((queroEntrar)
                            ? "Ainda não tem uma conta? Cadastre-se!"
                            : "Ja tem uma conta? Entre!"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    //validate testa todos campos que tem validator no formulario
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;

    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        print("entrada validada");
        _authenticatorService
            .logarUsuario(email: email, senha: senha)
            .then((String? erro) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          }
        });
      } else {
        print("cadastro validado");
        print(
            "${_emailController.text}, ${_senhaController.text}, ${_nomeController.text}");
        _authenticatorService
            .cadastrarUsuario(nome: nome, senha: senha, email: email)
            .then((String? erro) {
          //voltou com erro
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          }
        }); //then para quando cadastro de usuario terminar pegar o retorno
      }
    } else {
      print("Form inválido");
    }
  }
}
