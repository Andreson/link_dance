import 'package:flutter/material.dart';

class DataNotFoundComponent extends StatelessWidget {
  String message;
  void Function()? reload;

  DataNotFoundComponent(
      {this.message = "Nenhum resultado encontrado", this.reload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          OutlinedButton(onPressed: reload, child: Text("Limpar filtros"))
        ],
      ),
    );
  }
}
