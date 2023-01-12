import 'package:link_dance/components/movie/sliver_grid_movie.dart';
import 'package:link_dance/components/page/detail_simple_component.dart';
import 'package:link_dance/components/page/header_page_component.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/theme/fontStyles.dart';
import 'package:link_dance/components/movie/movie_item_list.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/model/content_user_acess_model.dart';
import 'package:link_dance/model/movie_model.dart';
import 'package:link_dance/model/vo/detail_screen_vo.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/repository/movie_repository.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../repository/base_repository.dart';

class ContentGroupDetailScreen extends StatefulWidget {
  @override
  State<ContentGroupDetailScreen> createState() =>
      _ContentGroupDetailScreenState();
}

class _ContentGroupDetailScreenState extends State<ContentGroupDetailScreen> {
  late ContentGroupModel contentGroup;
  late ContentGroupRepository contentGroupRepository;
  late Image banner;
  late ScrollController _scrollController;
  late MovieRepository movieRepository;
  late ContentUserAcessModel? userAccess;

  @override
  initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  String _titleAppBar() {
    var labelType = contentGroupdescriptions[contentGroup.type]?.text;

    return "$labelType de ${contentGroup.rhythm}";
  }

  @override
  Widget build(BuildContext context) {
    contentGroup =
        ModalRoute.of(context)?.settings.arguments as ContentGroupModel;
    contentGroupRepository =
        Provider.of<ContentGroupRepository>(context, listen: false);
    movieRepository = Provider.of<MovieRepository>(context, listen: false);

    movieRepository.findByContentGroup(contentGroup.id);

    var userId =
        Provider.of<AuthenticationFacate>(context, listen: false).user!.id;
    contentGroupRepository
        .getAcessUser(userId: userId, contentGroupId: contentGroup.id)
        .then((value) {
      userAccess = value;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar(), overflow: TextOverflow.ellipsis),
      ),
      body: customScroll(),
    );
  }

  Widget _accessLevelButton() {
    var temp = acessLevelData();

    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 15),
      child: TextButton.icon(
          icon: Icon(
            temp['icon'],
            color: Colors.black87,
            size: 16,
          ),
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              elevation: MaterialStateProperty.all(5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(color: Colors.black))),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: () {
            infoAccessContent();
          },
          label: Tooltip(
            message: "Tipo de acesso ao conteúdo das aulas",
            child: Text(
              temp['label'],
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          )),
    );
  }

  Map<String, dynamic> acessLevelData() {
    if (contentGroup.isPublic) {
      return {"label": "Público", "icon": FontAwesomeIcons.users};
    } else {
      return {"label": "Restrito", "icon": FontAwesomeIcons.lock};
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Hora de busca mais itens");
    }
  }

  Future<void> refresh() async {
    setState(() {
      //Provider.of<TeacherRepository>(context, listen: false).loadData();
    });
  }

  Widget customScroll() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var header = PageHeaderComponent(
        headerData: PageHeaderDetailVo(
            title: contentGroup.title,
            subTitle: [
              Text(contentGroup.school.capitalize(),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.normal))
            ],
            imageBackground: contentGroup.photo!,
            width: width,
            height: height));

    var detail = PageDetailSimpleComponent(
        bodyData: PageDetailBodyVo(
            title: contentGroupdescriptions[contentGroup.type]!.text,
            subTitle: [
              Text(
                "Prof. ${contentGroup.labelTeacher ?? ""}",
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.normal),
              )
            ],
            info: [
              Text(
                  "Aulas iniciam em ${contentGroup.startClassDate.toDate().showString()}")
            ],
            description: contentGroup.description ?? ""));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(children: [
            header,
            Stack(
              children: [
                Align(
                    alignment: Alignment.bottomRight,
                    child: _accessLevelButton()),
                sizedBox50(),
                detail,
              ],
            ),
            Text("Videos das aulas"),
            sizedBox15(),
          ]),
        ),
        Consumer<MovieRepository>(builder: (context, repository, child) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              print("Find  items in index $index");
              var data = repository.listData[index];
              bool blocAccess;
              if (!contentGroup.isPublic) {
                blocAccess = userAccess == null;
              } else {
                blocAccess = false;
              }

              return MovieItemListComponent(
                movie: data,
                blocAcess: blocAccess,
              );
            }, childCount: repository.listData.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
            ),
          );
        })
      ],
    );
  }

  Widget buildGridItem() {
    bool blocAccess;
    if (!contentGroup.isPublic) {
      blocAccess = userAccess == null;
    } else {
      blocAccess = false;
    }
    return SliverGridMovie(isBlock: blocAccess);
  }

  void infoAccessContent() {
    var temp = contentGroup.isPublic
        ? "Você pode acessar todos os videos da turma livremente"
        : "Você precisa solicitar ao professor da turma, que libere "
            "acesso para você.";

    var endLine =
        "O conteúdo dessa turma é ${contentGroup.labelAccessContent()}. $temp";

    showInfo(
        context: context,
        title: "O conteúdo dessa turma é ${contentGroup.labelAccessContent()}",
        content: "Turmas podem ter seu conteúdo publico ou restrito. "
            "\nTurmas com acesso \"Público\" permitem que todos possam ver os videos e conteúdo postado."
            "\nTurmas com acesso \"Restrito\" tem seu conteúdo restrito, e necessitam que o professor conceda acesso ao alunos."
            "\n$temp",
        labelButton: "Tendeu");
  }
}
