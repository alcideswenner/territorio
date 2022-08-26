import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/stores/changed_page_value.dart';
import 'package:territorio/views/mapa_view.dart';
import 'package:territorio/views/user_view.dart';
import 'package:territorio/views/inicio.dart';

import '../states/auth_state.dart';
import '../states/stateful_wrapper.dart';

class Home extends StatelessWidget {
  final pageController = PageController();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    final pageState = ChangedPageValue();
    return WillPopScope(
      child: StatefulWrapper(
        onInit: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
        },
        child: Scaffold(
          appBar: appBar(context),
          body: PageView(
            controller: pageController,
            onPageChanged: pageState.setValue,
            physics: const NeverScrollableScrollPhysics(),
            children: const <Widget>[Inicio(), MapaView()],
          ),
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: pageState,
              builder: (context, state, child) {
                return CupertinoTabBar(
                  currentIndex: pageState.value,
                  onTap: onTap,
                  activeColor: Theme.of(context).primaryColor,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home)),
                    BottomNavigationBarItem(icon: Icon(Icons.map)),
                  ],
                );
              }),
        ),
      ),
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Você deseja sair do APP?',
                style: Theme.of(context).textTheme.headline5,
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    SystemNavigator.pop();
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
    );
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut);
  }

  AppBar appBar(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Território Central"),
      actions: <Widget>[
        loginResponse.roles
                .where((element) => element.contains("SYSTEM"))
                .isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserView()));
                })
            : const SizedBox(),
        IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
      ],
    );
  }
}
