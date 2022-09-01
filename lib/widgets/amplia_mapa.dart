import 'dart:io';
import 'dart:developer' as dev;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

imagemAmpliada(BuildContext context, String titulo, String bairro,
    String linkImage, String numeroTerritorio, String urlGoogleMapas) {
  showDialog(
      context: context,
      builder: (_) => Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: linkImage,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        compartilhaImagemTexto(titulo, bairro, linkImage,
                            numeroTerritorio, urlGoogleMapas);
                      },
                    ),
                    const SizedBox(width: 10.0),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.map),
                      onPressed: () async {},
                    ),
                  ],
                )
              ],
            ),
          ));
}

void compartilhaImagemTexto(String titulo, String bairro, String linkImage,
    String numeroTerritorio, String urlGoogleMapas) async {
  try {
    var texto =
        """Prezado irmão, segue os dados do território a ser trabalhado:\n\nNúmero do território: $numeroTerritorio
      \nBairro: $bairro. \n\nCaso queira mais informações sobre o território, clique no link que direcionará ao google maps. \n$urlGoogleMapas""";
    var tempDir = await getTemporaryDirectory();
    final dio = Dio();
    final response = await dio
        .get("${linkImage.replaceAll(".png", "")}-C.png",
            options: Options(
                responseType: ResponseType.bytes, followRedirects: false))
        .onError((error, stackTrace) => dio.get(linkImage,
            options: Options(
                responseType: ResponseType.bytes, followRedirects: false)));

    final nmImage = '${tempDir.path}/teste.png';
    File file = File(nmImage);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);

    Share.shareFiles([(file.path)], text: texto);
  } catch (e) {
    dev.log('error: $e');
  }
}
