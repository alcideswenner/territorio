import 'package:cache_manager/core/delete_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territorio/states/stateful_wrapper.dart';
import 'package:territorio/states/user_list_all_state.dart';
import 'package:territorio/stores/user_list_all_store.dart';
import 'package:territorio/views/login_view.dart';
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

    return StatefulWrapper(
      onInit: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userStoreList.fetchListUsers(loginResponse.token);
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
                return Text("erro");
              }
              if (state is SucessUserListAllState) {
                return main(userStoreList, context);
              }
              return Text("oi");
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

  Widget main(UserListAllStore userStoreList, BuildContext context) {
    final listUsers = (userStoreList.value as SucessUserListAllState);
    return ListView.builder(
        itemCount: listUsers.users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listUsers.users[index].name.toString()),
          );
        });
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
}
