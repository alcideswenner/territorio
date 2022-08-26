import 'package:cache_manager/core/read_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:territorio/models/auth_login_request.dart';
import 'package:territorio/states/auth_state.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/views/home.dart';
import '../models/auth_login_response.dart';
import '../states/stateful_wrapper.dart';

class LoginView extends StatelessWidget {
  final usuario = TextEditingController();
  final senha = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeAuth = context.watch<AuthStore>();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Você deseja sair do APP?'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Sim'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Não'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: StatefulWrapper(
          onInit: () {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              storeAuth.init();
              await ReadCache.getJson(key: "user")
                  .then((value) => {
                        if (DateTime.fromMillisecondsSinceEpoch(
                                int.parse(value["teste"].toString()))
                            .isAfter(DateTime.now()))
                          {
                            storeAuth
                                .loginCache(AuthLoginResponse.fromJson(value))
                          }
                      })
                  .onError((error, stackTrace) {
                return {};
              });
            });
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 27, 96, 160),
              centerTitle: true,
              title: const Text("Mapas da Congregação Central",
                  textAlign: TextAlign.center),
            ),
            backgroundColor: const Color(0xFF003B73),
            body: ValueListenableBuilder(
                valueListenable: storeAuth,
                builder: (context, state, child) {
                  if (state is InitialAuthState) {
                    return main(storeAuth, context);
                  }
                  if (state is LoadingAuthState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ErrorAuthState) {
                    exibeMsgError(context, state.message, storeAuth);
                    return main(storeAuth, context);
                  }
                  if (state is SucessAuthState) {
                    carregaTelaHome(context, storeAuth);
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return main(storeAuth, context);
                }),
            bottomSheet: Container(
              alignment: Alignment.center,
              height: 20,
              color: const Color.fromARGB(255, 27, 96, 160),
              child: const Text(
                "Território",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ));
  }

  Widget textUser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        elevation: 0.0,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: TextFormField(
            style: Theme.of(context).textTheme.headline2,
            autovalidateMode: AutovalidateMode.always,
            controller: usuario,
            toolbarOptions: const ToolbarOptions(
                copy: true, cut: false, paste: true, selectAll: true),
            decoration: InputDecoration(
                hintText: "usuário",
                prefixIcon: Material(
                  color: Colors.white54,
                  elevation: 0,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20))),
      ),
    );
  }

  Widget textSenha(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        elevation: 0.0,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: TextFormField(
          style: Theme.of(context).textTheme.headline2,
          autovalidateMode: AutovalidateMode.always,
          toolbarOptions: const ToolbarOptions(
              copy: true, cut: false, paste: true, selectAll: true),
          controller: senha,
          obscureText: true,
          onChanged: (String value) {},
          cursorColor: Colors.deepOrange,
          decoration: InputDecoration(
              hintText: "Senha",
              prefixIcon: Material(
                elevation: 0,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20)),
        ),
      ),
    );
  }

  Widget btnLogin(AuthStore authStore, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 27, 96, 160),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
                onSurface: Colors.red,
              ),
              onPressed: () {
                authStore.fetchAuthLogin(AuthLoginRequest(
                    login: usuario.text, password: senha.text));
              },
              child: Text('Login', style: Theme.of(context).textTheme.button),
            )));
  }

  Widget main(AuthStore authStore, BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        Ink(
          child: Image(
            width: MediaQuery.of(context).size.width - 200,
            height: 120,
            color: Colors.white70,
            image: const AssetImage("assets/images/icon_territorio.png"),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text("Informe suas credenciais",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3),
        const SizedBox(
          height: 30,
        ),
        Form(
          child: textUser(context),
        ),
        const SizedBox(
          height: 20,
        ),
        textSenha(context),
        const SizedBox(
          height: 25,
        ),
        btnLogin(authStore, context),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  void exibeMsgError(
      BuildContext context, String mensagem, AuthStore authStore) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {},
        ),
      ));
      authStore.init();
    });
  }

  void carregaTelaHome(BuildContext context, AuthStore storeAuth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
    });
  }
}
