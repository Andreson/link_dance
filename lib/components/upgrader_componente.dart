

import 'package:flutter/cupertino.dart';
import 'package:upgrader/upgrader.dart';

class UpgradeAppVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var upgrader = Upgrader(languageCode: "pt",minAppVersion: "0.0.1",);
    return Container(
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
        child: UpgradeCard( upgrader: upgrader ,));
  }

}