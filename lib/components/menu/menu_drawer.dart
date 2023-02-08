import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:link_dance/components/menu/menu_factory.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuOptionsComponent extends StatelessWidget {
  UserModel user;

  MenuOptionsComponent({required this.user});

  late ImageAvatarComponent imageAvatar;

  @override
  Widget build(BuildContext context) {
    imageAvatar = _getImageProfile(imageUrl: user.photoUrl);
    return Drawer(
      child: Stack(
        children: [
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user.name!),
                accountEmail: Text(user.email!),
                currentAccountPicture: imageAvatar,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.3,
                    image: AssetImage(
                      "assets/images/drawer_profile_backgroud.png",
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              MenuFactory(context: context, user: user).menuFactory(),
              Consumer<AuthenticationFacate>(
                builder: (context, auth, child) => ListTile(
                  leading: const Icon(
                    Icons.logout,
                  ),
                  title: const Text('Sair'),
                  onTap: () {
                    Navigator.pop(context);
                    auth.logout().then((value) =>
                        Navigator.pushNamed(context, RoutesPages.login.name));
                  },
                ),
              ),
            ],
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black38,
              ),
              margin: const EdgeInsets.only(top: 100, left: 25),
              child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Text(user.userTypeLabel())))
        ],
      ),
    );
  }

  ImageAvatarComponent _getImageProfile(
      {String? imageUrl, String? imageLocal}) {
    return ImageAvatarComponent(
      imageLocal: imageLocal ?? ConstantsImagens.defaultAvatar,
      imageUrl: imageUrl,
    );
  }

  Widget buildTags(List<String> tagsData) {
    const double edges = 5;
    return ChipsChoice<int>.single(
      choiceStyle: const C2ChoiceStyle(
        elevation: 0,
        color: Colors.black,
        showCheckmark: true,
        labelStyle: TextStyle(fontSize: 10),
        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        //borderColor: Colors.blueGrey.withOpacity(0.2),
      ),
      onChanged: (val) {},
      value: tagsData.length,
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      choiceItems: C2Choice.listFrom<int, String>(
        source: tagsData,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
    );
  }
}
