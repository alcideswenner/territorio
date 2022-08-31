import 'dart:io';

import 'package:cache_manager/core/delete_cache_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:territorio/models/auth_login_response.dart';
import 'package:territorio/models/mapa.dart';
import 'package:territorio/states/concluir_designacao_state.dart';
import 'package:territorio/states/designacao_add_state.dart';
import 'package:territorio/states/mapas_list_all_state.dart';
import 'package:territorio/states/stateful_wrapper.dart';
import 'package:territorio/stores/changed_value_drop.dart';
import 'package:territorio/stores/concluir_designacao_store.dart';
import 'package:territorio/stores/designacao_add_store.dart';
import 'package:territorio/widgets/amplia_mapa.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/designacao.dart';
import '../models/user.dart';
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
    final designacaoAddStore =
        Provider.of<DesignacaoAddStore>(context, listen: true);
    final concluirDesignacaoStore =
        Provider.of<ConcluirDesignacaoStore>(context, listen: true);
    final changedValueDrop = ChangedValueDrop();
    return StatefulWrapper(
      onInit: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          changedValueDrop.init();
          mapaStoreList.fetchListMapas(loginResponse.token);
        });
      },
      child: Scaffold(
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
                exibeMsgError(context, state.message,
                    designacaoAddStore: designacaoAddStore);
                return const Text("erro");
              }
              if (state is SucessMapasListAllState) {
                return main(
                    mapaStoreList,
                    context,
                    designacaoAddStore,
                    loginResponse,
                    mapaStoreList,
                    concluirDesignacaoStore,
                    changedValueDrop);
              }
              return const Text("oi");
            }),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            changedValueDrop.init();
            mapaStoreList.fetchListMapas(loginResponse.token);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget main(
      MapasListAllStore mapasListAllState,
      BuildContext context,
      DesignacaoAddStore designacaoAddStore,
      AuthLoginResponse loginResponse,
      MapasListAllStore mapaStoreList,
      ConcluirDesignacaoStore concluirDesignacaoStore,
      ChangedValueDrop changedValueDrop) {
    final listMapas = (mapasListAllState.value as SucessMapasListAllState);

    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 27, 96, 160)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filtrar por bairro",
                  style: TextStyle(color: Colors.white),
                ),
                ValueListenableBuilder(
                    valueListenable: changedValueDrop,
                    builder: (context, state, child) {
                      return DropdownButton(
                          dropdownColor: const Color.fromARGB(255, 27, 96, 160),
                          focusColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          value: changedValueDrop.value,
                          items: changedValueDrop.items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? val) async {
                            await changedValueDrop.setValue(val);
                            if (val!.contains("Todos os Mapas")) {
                              mapaStoreList.fetchListMapas(loginResponse.token);
                            } else {
                              mapaStoreList.fetchListMapas(loginResponse.token,
                                  bairro: val.toString());
                            }

                            await changedValueDrop.setValue(val);
                          });
                    })
              ],
            )),
        Expanded(
          child: ListView.separated(
            itemCount: listMapas.mapas.length,
            itemBuilder: (context, index) {
              Mapa mapa = listMapas.mapas[index];
              return cardMapa(mapa, context, designacaoAddStore, loginResponse,
                  mapaStoreList, concluirDesignacaoStore);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 3,
                color: Colors.black12,
              );
            },
          ),
        )
      ],
    );
  }

  Container cardMapa(
      Mapa item,
      BuildContext context,
      DesignacaoAddStore designacaoAddStore,
      AuthLoginResponse loginResponse,
      MapasListAllStore mapaStoreList,
      ConcluirDesignacaoStore concluirDesignacaoStore) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      imagemAmpliada(context, item.nome, item.nome,
                          item.urlMapa, "${item.numeroTerritorio}");
                    },
                    child: CachedNetworkImage(
                      imageUrl: item.urlMapa,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Ink(
                    height: 150,
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
                      trailing: const Text(
                        "",
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (item.status == false) {
                        final designacao = Designacao(
                            dataDesignacao: DateTime.now().toIso8601String(),
                            user: User.id(id: loginResponse.idUser),
                            mapa: Mapa.id(id: item.id));
                        addDesignacao(designacaoAddStore, loginResponse,
                            mapaStoreList, context, designacao);
                      } else if ((item.status == true) &&
                          (item.userAtual == loginResponse.idUser)) {
                        concluirDesignacao(
                            concluirDesignacaoStore,
                            loginResponse,
                            item.designacaoId,
                            mapaStoreList,
                            context,
                            item.numeroTerritorio,
                            item.urlMapa);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: item.status == false
                            ? Colors.green[500]
                            : (item.userAtual == loginResponse.idUser)
                                ? Colors.blue[500]
                                : Colors.red[500]),
                    child: Text(
                      item.status == false
                          ? "Escolher Mapa"
                          : (item.userAtual == loginResponse.idUser)
                              ? "Concluir Designação"
                              : "Mapa indisponível",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(10.0)),
                    onPressed: () {},
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.description),
                        Text("Anotações")
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    item.msgDataCarencia,
                    style: const TextStyle(color: Colors.red),
                  ))
                ],
              ),
              TextButton(
                  onPressed: () {
                    abrirGoogleMaps(item.urlGoogleMaps);
                  },
                  child: const Text(
                    "Abrir no Google Maps",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void addDesignacao(
      DesignacaoAddStore designacaoAddStore,
      AuthLoginResponse loginResponse,
      MapasListAllStore mapaStoreList,
      BuildContext context,
      Designacao designacao) async {
    await designacaoAddStore.fetchSalvaDesignacao(
        designacao, loginResponse.token);
    //mapaStoreList.fetchListMapas(loginResponse.token);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (designacaoAddStore.value is ErrorDesignacaoAddState) {
        final error =
            (designacaoAddStore.value as ErrorDesignacaoAddState).message;
        exibeMsgError(context, error, designacaoAddStore: designacaoAddStore);
      }
      if (designacaoAddStore.value is SucessDesignacaoAddState) {
        exibeMsg(context, "Designado com Sucesso", designacaoAddStore);
      }
      mapaStoreList.fetchListMapas(loginResponse.token);
    });
  }

  void exibeMsgError(BuildContext context, String error,
      {DesignacaoAddStore? designacaoAddStore,
      ConcluirDesignacaoStore? concluirDesignacaoStore}) {
    designacaoAddStore!.init();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    ));
    if (error.contains("Sessão expirada ou não autorizado!")) {
      DeleteCache.deleteKey("user");
      Navigator.popUntil(context, ModalRoute.withName('/'));
      concluirDesignacaoStore!.init();
      /*  Navigator.of(context).popAndPushNamed("/"); */
    }
  }

  void exibeMsg(
      BuildContext context, String msg, DesignacaoAddStore designacaoAddStore) {
    designacaoAddStore.init();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    ));
  }

  void concluirDesignacao(
      ConcluirDesignacaoStore concluirDesignacaoStore,
      AuthLoginResponse loginResponse,
      int id,
      MapasListAllStore mapaStoreList,
      BuildContext context,
      int numeroTerritorio,
      String urlMapa) async {
    await concluirDesignacaoStore.fetchConcluirDesignacao(
        id, loginResponse.token);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (concluirDesignacaoStore.value is ErrorConcluirDesignacaoState) {
        final error =
            (concluirDesignacaoStore.value as ErrorConcluirDesignacaoState)
                .message;
        exibeMsgError(context, error,
            concluirDesignacaoStore: concluirDesignacaoStore);
      }
      if (concluirDesignacaoStore.value is SucessConcluirDesignacaoState) {
        //salvarMapasLocais(urlMapa, numeroTerritorio);
      }
      mapaStoreList.fetchListMapas(loginResponse.token);
    });
  }

  abrirGoogleMaps(String urlGoogleMaps) async {
    final Uri url = Uri.parse(urlGoogleMaps);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

/*   void salvarMapasLocais(String linkImage, int numTerritorio) async {
    var tempDir = await getApplicationDocumentsDirectory();
    final dio = Dio();
    final response = await dio.get(linkImage,
        options:
            Options(responseType: ResponseType.bytes, followRedirects: false));

    final nmImage = '${tempDir.path}/mapa-$numTerritorio.png';
    File file = File(nmImage);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
  } */
}
