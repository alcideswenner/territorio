import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/views/user_view.dart';
import 'package:territorio/views/inicio.dart';

import '../states/auth_state.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  PageController? pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    return WillPopScope(
      // ignore: sort_child_properties_last
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.map),
          onPressed: () {},
        ),
        appBar: appBar(),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[Inicio(), Inicio()],
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Theme.of(context).primaryColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.history)),
          ],
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

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.animateToPage(pageIndex,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOut);
  }

  AppBar appBar() {
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
