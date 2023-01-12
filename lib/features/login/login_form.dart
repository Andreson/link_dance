import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/routes.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/login/login_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginFormComponent extends StatefulWidget {
  void Function() onSubmit;

  LoginFormComponent({required this.onSubmit});

  @override
  State<LoginFormComponent> createState() => _LoginFormComponentState();
}

class _LoginFormComponentState extends State<LoginFormComponent> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  late AuthenticationFacate authentication;
  late  LoginHelper loginHelper ;


  @override
  Widget build(BuildContext context) {
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    loginHelper = LoginHelper(context: context);
    return Column(
      children: [
        sizedBox30(),
        const Text("Acessar sua conta"),
        sizedBox30(),
        _inputFields(),
        sizedBox30(),
      ],
    );
  }

  Column _inputFields() {
    return Column(
      children: [
        SizedBox(
          width: 260,
          height: 50,
          child: TextField(
            controller: _loginController,
            decoration: const InputDecoration(
                suffix: Icon(
                  FontAwesomeIcons.envelope,
                  color: Colors.white,
                ),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                )),
          ),
        ),
        sizedBox30(),
        SizedBox(
          width: 260,
          height: 50,
          child: TextFormField(
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              loginHelper.login(loginProvider: LoginProvider.email,password:  _passwordController.text,
              username: _loginController.text);

            },
            controller: _passwordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
                labelText: "Senha",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                )),
          ),
        ),
        sizedBox30(),
        CustomTextButton(
            onPressed: () {
              loginHelper.login(loginProvider: LoginProvider.email,password:  _passwordController.text,
                  username: _loginController.text);
            },
            label: "Login"),
      ],
    );
  }
}
