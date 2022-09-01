import 'package:flutter/material.dart';

alertaPadrao(BuildContext context, Function acao, String msg) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(msg,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  acao();
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
          ));
}
