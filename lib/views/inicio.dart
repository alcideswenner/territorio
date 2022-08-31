import 'package:cache_manager/core/delete_cache_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:territorio/models/rankign_bairro_mais_trabalhado.dart';
import 'package:territorio/states/auth_state.dart';
import 'package:territorio/states/ranking_bairro_mais_trabalhado_state.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/stores/ranking_bairro_mais_trabalhado_store.dart';
import '../models/auth_login_response.dart';
import '../models/mapa.dart';
import '../states/concluir_designacao_state.dart';
import '../states/mapas_list_all_state.dart';
import '../states/stateful_wrapper.dart';
import '../stores/concluir_designacao_store.dart';
import '../stores/designacao_add_store.dart';
import '../stores/mapas_list_all_store.dart';
import '../widgets/amplia_mapa.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapaStoreList = Provider.of<MapasListAllStore>(context, listen: true);
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;
    final concluirDesignacaoStore =
        Provider.of<ConcluirDesignacaoStore>(context, listen: true);
    final rankingStore = context.watch<RankingBairroMaisTrabalhadoStore>();
    return StatefulWrapper(
        onInit: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapaStoreList.fetchListMapas(loginResponse.token,
                idUser: loginResponse.idUser);

            rankingStore.fetchRanking(loginResponse.token);
          });
        },
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              header(context),
              local(context),
              sectionMapasEmProgresso(context),
              ValueListenableBuilder(
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
                      return const Text("erro");
                    }
                    if (state is SucessMapasListAllState) {
                      final listMapas =
                          (mapaStoreList.value as SucessMapasListAllState);
                      return listMapas.mapas.isNotEmpty
                          ? bodyMapaProgresso(
                              listMapas,
                              concluirDesignacaoStore,
                              loginResponse,
                              mapaStoreList)
                          : SizedBox(
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Center(
                                    child: Icon(Icons.branding_watermark),
                                  ),
                                  Divider(),
                                  Center(
                                    child: Text("Nenhum mapa escolhido"),
                                  )
                                ],
                              ),
                            );
                    }
                    return const Text("oi");
                  }),
              _buildDefaultPieChart(context, loginResponse.token, rankingStore)
            ],
          ),
        )));
  }

  header(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final loginResponse = (auth.value as SucessAuthState).authLoginResponse;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/home.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      margin: const EdgeInsets.only(top: 3.0, bottom: 10.0),
      height: 190.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 35.0, right: 35.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text("Olá, ${loginResponse.username}",
                      style: Theme.of(context).textTheme.headline5),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text("Publicador | Mapas"),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              "29",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Mapas".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              "100+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Publicadores".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text(
                              "40.000+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Cidade".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Material(
                elevation: 4.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 28.0,
                    backgroundImage: AssetImage("assets/images/user.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  sectionMapasEmProgresso(BuildContext context) {
    return Container(
      height: 35,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white10),
      child: Text(
        "Mapas em Progresso",
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }

  Widget bodyMapaProgresso(
      SucessMapasListAllState listMapas,
      ConcluirDesignacaoStore concluirDesignacaoStore,
      AuthLoginResponse loginResponse,
      MapasListAllStore mapaStoreList) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: listMapas.mapas.length,
        itemBuilder: (context, index) {
          Mapa mapa = listMapas.mapas[index];
          //timestamp = snap.data.documents[index].data["timestamp"];
          return Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              width: 195.0,
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: GestureDetector(
                            onTap: () {
                              imagemAmpliada(context, mapa.nome, mapa.nome,
                                  mapa.urlMapa, "${mapa.numeroTerritorio}");
                            },
                            child: CachedNetworkImage(
                              imageUrl: mapa.urlMapa,
                              placeholder: (context, url) =>
                                  const LinearProgressIndicator(
                                      color: Colors.black12,
                                      backgroundColor: Colors.grey),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ))),
                  const SizedBox(
                    height: 5.0,
                  ),
                  ListTile(
                    subtitle: Text(
                      "Território nº ${mapa.numeroTerritorio}",
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    title: Text(mapa.nome,
                        style: Theme.of(context).textTheme.subtitle1),
                    leading: IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(
                          Icons.cloud_download,
                          size: 30,
                        ),
                        onPressed: () {
                          concluirDesignacao(
                              concluirDesignacaoStore,
                              loginResponse,
                              mapaStoreList,
                              context,
                              mapa.designacaoId);
                        }),
                  )
                ],
              ));
        },
      ),
    );
  }

  void concluirDesignacao(
      ConcluirDesignacaoStore concluirDesignacaoStore,
      AuthLoginResponse loginResponse,
      MapasListAllStore mapaStoreList,
      BuildContext context,
      int idDesignacao) async {
    await concluirDesignacaoStore.fetchConcluirDesignacao(
        idDesignacao, loginResponse.token);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (concluirDesignacaoStore.value is ErrorConcluirDesignacaoState) {
        final error =
            (concluirDesignacaoStore.value as ErrorConcluirDesignacaoState)
                .message;
        exibeMsgError(context, error,
            concluirDesignacaoStore: concluirDesignacaoStore);
      }
      if (concluirDesignacaoStore.value is SucessConcluirDesignacaoState) {}
      mapaStoreList.fetchListMapas(loginResponse.token,
          idUser: loginResponse.idUser);
    });
  }

  Widget local(BuildContext context) {
    return ListTile(
      title: Text(
        "Coelho Neto - Ma",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
      leading: const Icon(Icons.location_on),
      trailing: GestureDetector(
        onTap: () {},
        child: const Text("Brasil"),
      ),
      subtitle: const Text("Congregação Central"),
    );
  }

  void exibeMsgError(BuildContext context, String error,
      {DesignacaoAddStore? designacaoAddStore,
      ConcluirDesignacaoStore? concluirDesignacaoStore,
      MapasListAllStore? mapaStoreList}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        designacaoAddStore!.init();
        concluirDesignacaoStore?.init();
        mapaStoreList!.init();
      }
    });
  }

  SizedBox _buildDefaultPieChart(BuildContext context, String token,
      RankingBairroMaisTrabalhadoStore rankingStore) {
    return SizedBox(
      child: ValueListenableBuilder(
          valueListenable: rankingStore,
          builder: (context, state, child) {
            if (state is SucessRankingBairroMaisTrabalhadoState) {
              return SfCircularChart(
                title: ChartTitle(text: 'Bairros mais trabalhados \n por ano'),
                legend: Legend(isVisible: true),
                series: _getDefaultPieSeries(state.ranking),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  /// Returns the pie series.
  List<PieSeries<RankingBairroMaisTrabalhado, String>> _getDefaultPieSeries(
      List<RankingBairroMaisTrabalhado> ranking) {
    return <PieSeries<RankingBairroMaisTrabalhado, String>>[
      PieSeries<RankingBairroMaisTrabalhado, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: ranking,
          xValueMapper: (RankingBairroMaisTrabalhado data, _) => data.bairro,
          yValueMapper: (RankingBairroMaisTrabalhado data, _) => data.qtd,
          dataLabelMapper: (RankingBairroMaisTrabalhado data, _) => data.bairro,
          startAngle: 90,
          endAngle: 90,
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }
}
