import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/screens/login/login_form.dart';

import 'package:link_dance/components/reset_password_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/features/login/login_helper.dart';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/decorators/box_decorator.dart';
import '../../core/routes.dart';
import '../../core/factory_widget.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationFacate authentication;
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  late  LoginHelper loginHelper ;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showPassword = false;

  void initState() {
    super.initState();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
   loginHelper = LoginHelper(context: context);
    loginHelper.tryAutoLogin();
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: boxImage("assets/images/large/home.png", opacity: 0.6),
          child: body(context),
        ));
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(child: _header()),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            decoration: box(opacity: 0.3, allBorderRadius: 15),
            child: LoginFormComponent(onSubmit: () {
              loginHelper.login(loginProvider: LoginProvider.email);
            }),
          ),
        ),
        Expanded(child: _footer()),
      ],
    );
  }

  Widget _header() {
    return Column(
      children: [
        sizedBox50(),
         Text(
          "LinkDance",
          style: TextStyle(fontSize: 28,shadows: [shadowText()], fontWeight: FontWeight.bold),
        ),
        sizedBox10(),
         Text(
          "Aqui a felicidade não tem preço, tem ritmo.",
          style: TextStyle(
            shadows: [shadowText()],
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        sizedBox30(),
      ],
    );
  }

  Widget _footer() {
    return Column(
      children: [
        sizedBox15(),
        _socialNetworkButtons(),
        sizedBox15(),
        _auxButtons()
      ],
    );
  }

  Widget _socialNetworkButtons() {
    return Column(
      children: [
        const Text(
          "Ou entre usando rede social",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // IconButton(
            //     onPressed: () {
            //       loginHelper.login(loginProvider: LoginProvider.facebook);
            //     },
            //     icon:
            //         const Icon(FontAwesomeIcons.facebook, color: Colors.blue)),
            IconButton(
                onPressed: () {
                  loginHelper.login(loginProvider: LoginProvider.google);
                },
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.redAccent,
                )),
            // IconButton(
            //     onPressed: () {
            //       loginHelper.login(loginProvider: LoginProvider.instagran);
            //     },
            //     icon: const Icon(
            //       FontAwesomeIcons.instagram,
            //       color: Colors.orangeAccent,
            //     )),
          ],
        ),
      ],
    );
  }

  Widget _auxButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: _auxButtonStyle(),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ResetPasswordComponent(_scaffoldKey.currentContext!);
                });
          },
          child: const Text(
            "Recuperar senha",
            style: TextStyle(color: Colors.white),
          ),
        ),
        OutlinedButton(
          style: _auxButtonStyle(),
          onPressed: () {
            Navigator.pushNamed(context, RoutesPages.registration.name);
          },
          child: const Text(
            "Criar novo usuario",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  ButtonStyle _auxButtonStyle() {
    return ButtonStyle(
      visualDensity: VisualDensity.compact,
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.only(right: 30, left: 30)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    _loginController.dispose();
  }
}
