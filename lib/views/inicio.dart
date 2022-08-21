import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:territorio/states/auth_state.dart';
import 'package:territorio/stores/auth_store.dart';
import 'package:territorio/views/mapa_view.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        header(context),
        local(),
        sectionMeuMapas(context),
        sectionMapasTrabalhados(),
      ],
    ));
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
            padding: const EdgeInsets.only(
                top: 40.0, left: 35.0, right: 35.0, bottom: 5.0),
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

  sectionMeuMapas(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Meus mapas (Offline)",
            style: Theme.of(context).textTheme.headline2,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapaView()));
            },
            child: Text(
              "Escolher novo mapa",
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  sectionMapasTrabalhados() {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
        child: Text("Mapas Designados",
            style: Theme.of(context).textTheme.headline6));
  }

  Widget local() {
    return ListTile(
      title: Text(
        "Coelho Neto - Ma",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
      leading: Icon(Icons.location_on),
      trailing: Text("Brasil"),
      subtitle: Text("Congregação Central"),
    );
  }
}
