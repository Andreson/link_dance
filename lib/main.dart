import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:link_dance/components/movie/video_play.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/repository/event_repository.dart';
import 'package:link_dance/repository/follow_repository.dart';
import 'package:link_dance/repository/movie_repository.dart';
import 'package:link_dance/repository/notify_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/repository/user_repository.dart';
import 'package:link_dance/screens/login/login_screen.dart';
import 'package:link_dance/screens/movie_play_screen.dart';
import 'package:link_dance/screens/movie_upload_screen.dart';
import 'package:link_dance/screens/event_register_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './core/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBYjavKCwFGGfspj_ThSugG6C8MXZm9-x0",
      appId: "1:325634634089:android:39ba96a9be77da9cb20df8",
      messagingSenderId: "325634634089",
      projectId: "linkdance-691ad",
    ),
  );
  runApp(DevicePreview(
    builder: (_) => MyApp(),
    enabled: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleAppBar = const Text("LinkDance");
    var authentication = AuthenticationFacate();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => authentication,
        ),
        ChangeNotifierProxyProvider<AuthenticationFacate, TeacherRepository?>(
            create: (_) => TeacherRepository.New(),
            update: (ctx, authProvider, previusRepository) {
              return TeacherRepository(
                  auth: authProvider, data: previusRepository?.listData);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate, UserRepository?>(
            create: (_) => UserRepository.New(),
            update: (ctx, authProvider, previusRepository) {
              return UserRepository(auth: authProvider);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate, MovieRepository?>(
            create: (_) => MovieRepository(auth: authentication),
            update: (ctx, authProvider, previusRepository) {
              return MovieRepository(
                  auth: authProvider, data: previusRepository?.listData);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate, EventRepository?>(
            create: (_) => EventRepository.New(),
            update: (ctx, authProvider, previusRepository) {
              return EventRepository(
                  auth: authProvider, data: previusRepository?.listData);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate,
                ContentGroupRepository?>(
            create: (_) => ContentGroupRepository(),
            update: (ctx, authProvider, previusRepository) {
              return ContentGroupRepository(auth: authProvider);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate, FollowRepository?>(
            create: (_) => FollowRepository(),
            update: (ctx, authProvider, previusRepository) {
              return FollowRepository(auth: authProvider);
            }),
        ChangeNotifierProxyProvider<AuthenticationFacate,
                NotifyMessageRepository?>(
            create: (_) => NotifyMessageRepository(),
            update: (ctx, authProvider, previusRepository) {
              return NotifyMessageRepository(auth: authProvider);
            }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LinkDance',
        supportedLocales: const [Locale('pt', 'BR')],
        routes: routes,
          localizationsDelegates:  const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
        theme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Oswald',
              ),
        ),
        builder: DevicePreview.appBuilder,
        locale: DevicePreview.locale(context),
        home: LoginScreen(),
      ),
    );
  }
}
