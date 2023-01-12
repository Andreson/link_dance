import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuOptionsComponent extends StatelessWidget {
  UserModel user;

  MenuOptionsComponent({required this.user});



  late ImageAvatarComponent imageAvatar;

  @override
  Widget build(BuildContext context) {
    imageAvatar = _getImageProfile(imageUrl: user.photoUrl);
    return Drawer(
      child: Container(
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
                menusProfile(context),
                if (user.userType == UserType.professor) menusTeacher(context),
                if (user.userType == UserType.aluno) menusStudent(context),
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
                margin: EdgeInsets.only(top: 100, left: 25),
                child: Padding(
                    padding: EdgeInsets.all(1),
                    child: Text(user.userTypeLabel())))
          ],
        ),
      ),
    );
  }

  ImageAvatarComponent _getImageProfile(
      {String? imageUrl, String? imageLocal}) {
    return ImageAvatarComponent(
      imageLocal: imageLocal ?? Constants.defaultAvatar,
      imageUrl: imageUrl,

    );
  }


  Widget menusStudent(BuildContext context) {
    return Column(
      children: [],
    );
  }

  Widget menusProfile(BuildContext context) {
    return Column(
      children: [
        _mainItemMenu(
            context: context,
            itens: [
              _itemMenu(
                  label: "Minha conta",
                  context: context,
                  destination: RoutesPages.registration,arguments: user),
              if (user.userType == UserType.professor)
                _itemMenu(
                    label: "Perfil de Professor",
                    context: context,
                    destination: RoutesPages.teacherForm,
                    arguments: user.teacherProfile)
            ],
            label: "Perfil",
            icon: FontAwesomeIcons.user),
      ],
    );
  }

  Widget menusTeacher(BuildContext context) {
    return Column(children: [
      _mainItemMenu(
          icon: FontAwesomeIcons.photoFilm,
          context: context,
          label: "Videos",
          itens: [
            _itemMenu(
                label: "Upload video",
                context: context,
                destination: RoutesPages.movieUpload),
            _itemMenu(
                label: "Meus videos",
                context: context,
                destination: RoutesPages.movieAdmin)
          ]),
      _mainItemMenu(
          icon: FontAwesomeIcons.peopleGroup,
          context: context,
          label: "Turmas",
          itens: [
            _itemMenu(
                label: "Criar turma",
                context: context,
                destination: RoutesPages.contentGroup),
            _itemMenu(
                label: "Minhas turmas",
                context: context,
                destination: RoutesPages.contentGroupList,
                arguments: false)
          ]),
      _mainItemMenu(
          icon: FontAwesomeIcons.whatsapp,
          context: context,
          label: "Notificações",
          itens: [
            _itemMenu(
                label: "Enviar mensagem",
                context: context,
                destination: RoutesPages.notificationRegistry),
            _itemMenu(
                label: "Gerenciar mensagens",
                context: context,
                destination: RoutesPages.notificationAdmin)
          ]),
      _mainItemMenu(
          context: context,
          itens: [
            _itemMenu(
                label: "Novo evento",
                context: context,
                destination: RoutesPages.eventRegister),
            _itemMenu(
                label: "Meus eventos",
                context: context,
                destination: RoutesPages.eventList,
                arguments: false),
          ],
          label: "Eventos",
          icon: FontAwesomeIcons.icons)
    ]);
  }

  ExpansionTile _mainItemMenu(
      {required BuildContext context,
      required List<Widget> itens,
      required String label,
      required IconData icon}) {
    return ExpansionTile(
        title: Text(label),
        leading: Icon(
          icon,
        ),
        children: itens);
  }

  Widget _itemMenu(
      {required String label,
      required BuildContext context,
      required RoutesPages destination,
      Object? arguments}) {
    return ListTile(
      contentPadding: _tillerPassing(),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, destination.name, arguments: arguments);
      },
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

  EdgeInsets _tillerPassing() {
    return EdgeInsets.only(left: 70);
  }
}
