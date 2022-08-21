// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territorio/models/mapa.dart';
import 'package:territorio/states/mapas_list_all_state.dart';
import 'package:territorio/states/stateful_wrapper.dart';
import 'package:territorio/states/user_list_all_state.dart';
import 'package:territorio/views/user_add_view.dart';

import '../states/auth_state.dart';
import '../stores/auth_store.dart';
import '../stores/mapas_list_all_store.dart';

class MapaView extends StatelessWidget {
  const MapaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaStoreList = Provider.of<MapasListAllStore>(context, listen: true);
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;

    return StatefulWrapper(
      onInit: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapaStoreList.fetchListMapas(loginResponse.token);
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
            valueListenable: mapaStoreList,
            builder: (context, state, child) {
              if (state is InitialMapasListAllState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LoadingMapasListAllState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ErrorMapasListAllState) {
                exibeMsgError(context, state.message);
                return Text("erro");
              }
              if (state is SucessMapasListAllState) {
                return main(mapaStoreList, context);
              }
              return Text("oi");
            }),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            mapaStoreList.fetchListMapas(loginResponse.token);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget main(MapasListAllStore mapasListAllState, BuildContext context) {
    final listUsers = (mapasListAllState.value as SucessMapasListAllState);
    return ListView.builder(
        itemCount: listUsers.mapas.length,
        itemBuilder: (context, index) {
          Mapa mapa = listUsers.mapas[index];
          return cardMapa(mapa, context);
        });
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

  Container cardMapa(Mapa item, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: CachedNetworkImage(
                      imageUrl: item.urlMapa,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Ink(
                    height: 200,
                    decoration: const BoxDecoration(color: Colors.black12),
                  ),
                  Positioned(
                    right: 8,
                    top: 20,
                    child: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () {},
                      color: Colors.blue,
                      disabledColor: Colors.blue,
                    ),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                            padding: const EdgeInsets.all(10.0),
                            color: item.status == false
                                ? Colors.green[500]
                                : Colors.red[200],
                            child: Text(
                              item.status == false
                                  ? "Disponível"
                                  : "Indisponível",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ))
                ],
              ),
              const Divider(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                        item.nome,
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      subtitle: Text(
                        "Território nº ${item.numeroTerritorio}",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14),
                      ),
                      trailing: const Text("Atualização:-"),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.green[500],
                    child: Text(
                      item.status == false ? "Escolher Mapa" : "",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.description),
                        Text("Anotações")
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
