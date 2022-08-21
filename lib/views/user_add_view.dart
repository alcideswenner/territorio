import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territorio/models/auth_login_response.dart';
import 'package:territorio/models/permissao.dart';
import 'package:territorio/models/user.dart';
import 'package:territorio/states/user_add_state.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/stores/check_box_value.dart';
import 'package:territorio/stores/user_add_store.dart';
import 'package:territorio/stores/user_list_all_store.dart';
import 'package:territorio/views/user_view.dart';
import '../states/auth_state.dart';

class UserAddView extends StatelessWidget {
  UserAddView({Key? key}) : super(key: key);

  final controlerUsuarioTxt = TextEditingController();
  final controlerNomeTxt = TextEditingController();
  final controlerSenhaTxt = TextEditingController();
  final listaRoles = [];
  final values = <String, bool>{};

  @override
  Widget build(BuildContext context) {
    final storeUserAdd = context.watch<UserAddStore>();
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;
    final checkBoxValue = context.watch<CheckBoxValue>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de usuário"),
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
          valueListenable: storeUserAdd,
          builder: (context, state, child) {
            if (state is InitialUserAddState) {
              return form(checkBoxValue, loginResponse, storeUserAdd, context);
            }

            if (state is LoadingUserAddState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ErrorUserAddState) {
              exibeMsgError(context, state.message);
              return form(
                checkBoxValue,
                loginResponse,
                storeUserAdd,
                context,
              );
            }

            if (state is SucessUserAddState) {
              limpaForm(storeUserAdd, checkBoxValue, context);
              return form(
                checkBoxValue,
                loginResponse,
                storeUserAdd,
                context,
              );
            }

            return form(
              checkBoxValue,
              loginResponse,
              storeUserAdd,
              context,
            );
          }),
    );
  }

  Widget btnSalvar(UserAddStore userAddStore, String token,
      BuildContext context, CheckBoxValue checkBoxValue) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55),
        child: Container(
            width: MediaQuery.of(context).size.width - 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromARGB(255, 27, 96, 160),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
                onSurface: Colors.red,
              ),
              onPressed: () {
                List<Permissao> listaRoles = [];
                checkBoxValue.value.forEach((key, value) {
                  listaRoles.add(
                      Permissao(descricao: "Permissao", nomePermissao: key));
                });
                userAddStore.fetchSaveUser(
                    User(
                        username: controlerUsuarioTxt.text,
                        name: controlerNomeTxt.text,
                        password: controlerSenhaTxt.text,
                        permissao: listaRoles),
                    token);
              },
              child: Text('Salvar', style: Theme.of(context).textTheme.button),
            )));
  }

  Widget form(CheckBoxValue checkBoxValue, AuthLoginResponse loginResponse,
      UserAddStore storeUserAdd, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 25, left: 20, right: 30, top: 20),
      child: Column(children: [
        textField(
            controlerUsuarioTxt, "Usuário", const Icon(Icons.verified_user)),
        textField(controlerNomeTxt, "Nome", const Icon(Icons.person)),
        textField(controlerSenhaTxt, "Senha", const Icon(Icons.password)),
        ValueListenableBuilder(
            valueListenable: checkBoxValue,
            builder: (_, state, child) {
              return Column(
                children: [
                  CheckboxListTile(
                    title: const Text('SYSTEM'),
                    subtitle: const Text('Acesso de sistema'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: checkBoxValue.value.containsKey("SYSTEM"),
                    value: checkBoxValue.value.containsKey("SYSTEM"),
                    onChanged: (bool? value) {
                      values["SYSTEM"] = value!;
                      checkBoxValue.setValue(values);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('ADMIN'),
                    subtitle: const Text('Acesso de admin'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: checkBoxValue.value.containsKey("ADMIN"),
                    value: checkBoxValue.value.containsKey("ADMIN"),
                    onChanged: (bool? value) {
                      values["ADMIN"] = value!;
                      checkBoxValue.setValue(values);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('USER'),
                    subtitle: const Text('Acesso de usuário'),
                    secondary: const Icon(Icons.web),
                    activeColor: Colors.red,
                    checkColor: Colors.yellow,
                    selected: checkBoxValue.value.containsKey("USER"),
                    value: checkBoxValue.value.containsKey("USER"),
                    onChanged: (bool? value) {
                      values["USER"] = value!;
                      checkBoxValue.setValue(values);
                    },
                  )
                ],
              );
            }),
        const SizedBox(
          height: 35,
        ),
        btnSalvar(storeUserAdd, loginResponse.token, context, checkBoxValue)
      ]),
    );
  }

  Widget textField(TextEditingController controller, String label, Icon icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: icon,
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF6200EE),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
    );
  }

  void exibeMsgError(BuildContext context, String mensagem) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {},
        ),
      ));
    });
  }

  void exibeMsgSucess(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: const Text("Salvo!"),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'ok',
          onPressed: () {},
        ),
      ));
    });
  }

  void carregaTelaListUser(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserView(),
          ));
    });
  }

  void limpaForm(UserAddStore userAddStore, CheckBoxValue checkBoxValue,
      BuildContext context) {
    controlerNomeTxt.clear();
    controlerUsuarioTxt.clear();
    controlerSenhaTxt.clear();
    values.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exibeMsgSucess(context);
      userAddStore.init();
      checkBoxValue.init();
    });
  }
}
