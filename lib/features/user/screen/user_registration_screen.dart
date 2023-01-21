import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:flutter/material.dart';
import 'user_register_form.dart';
import '../../../core/decorators/box_decorator.dart';

class UserRegistrationScreen extends StatelessWidget {
   UserRegistrationScreen();
  final GlobalKey<RegistrationUserFormState> formKey = GlobalKey<RegistrationUserFormState>();
  @override
  Widget build(BuildContext context) {
    print("############################################## regirstration form screen call build #######################################");
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    var title = user==null?"Cadastrar usuario":"Meu Perfil";
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            actions: [
              if( user!=null)
              buttonSaveRegistry(onPressed: () {
                formKey.currentState?.submitForm();

              })
            ],
          title: Text(title),
        ),
        body:  Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              height: MediaQuery.of(context).size.height,
                  decoration: boxImage("assets/images/backgroud4.jpg"),
                  child: RegisterUserFormComponent(userModel: user,key: formKey,)),
          ),
        ),
        );
  }
}
