import 'package:cache_manager/core/delete_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territorio/models/auth_login_response.dart';
import 'package:territorio/states/stateful_wrapper.dart';
import 'package:territorio/states/user_list_all_state.dart';
import 'package:territorio/stores/user_list_all_store.dart';
import 'package:territorio/stores/user_remove_store.dart';
import 'package:territorio/views/user_add_view.dart';

import '../states/auth_state.dart';
import '../stores/auth_store.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userStoreList = Provider.of<UserListAllStore>(context, listen: true);
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;
    final userStoreRemove = Provider.of<UserRemoveStore>(context, listen: true);
    return StatefulWrapper(
      onInit: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userStoreList.fetchListUsers(loginResponse.token);
          userStoreRemove.init();
        });
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserAddView()));
                },
                icon: const Icon(Icons.person_add_alt))
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: userStoreList,
            builder: (context, state, child) {
              if (state is InitialUserListAllState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadingUserListAllState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ErrorUserListAllState) {
                exibeMsgError(context, state.message, userStoreList);
                return const Text("erro");
              }
              if (state is SucessUserListAllState) {
                return main(
                    userStoreList, context, loginResponse, userStoreRemove);
              }
              return const Text("oi");
            }),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            userStoreList.fetchListUsers(loginResponse.token);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget main(UserListAllStore userStoreList, BuildContext context,
      AuthLoginResponse loginResponse, UserRemoveStore userStoreRemove) {
    final listUsers = (userStoreList.value as SucessUserListAllState);

    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: listUsers.users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 2.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listUsers.users[index].username.toString())
                    ],
                  ),
                )),
                AspectRatio(
                  aspectRatio: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            userStoreRemove.fetchRemoveUser(
                                listUsers.users[index].id, loginResponse.token);
                            userStoreList.fetchListUsers(loginResponse.token);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Removido com sucesso"),
                              duration: const Duration(seconds: 1),
                              action: SnackBarAction(
                                label: 'ok',
                                onPressed: () {},
                              ),
                            ));
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  void exibeMsgError(
      BuildContext context, String mensagem, UserListAllStore userStoreList) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {},
        ),
      ));
      if (mensagem.contains("Sessão expirada ou não autorizado!")) {
        DeleteCache.deleteKey("user");
        Navigator.popUntil(context, ModalRoute.withName('/'));
        userStoreList.value = InitialUserListAllState();
        /*  Navigator.of(context).popAndPushNamed("/"); */
      }
    });
  }

  void exibeMsg(
      BuildContext context, String msg, UserRemoveStore userStoreRemove) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userStoreRemove.init();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'ok',
          onPressed: () {},
        ),
      ));
    });
  }
}
