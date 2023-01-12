// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/components/page/detail_simple_component.dart';
import 'package:link_dance/components/page/header_page_component.dart';

import 'package:link_dance/components/movie/movie_item_list.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';

import 'package:link_dance/model/content_user_acess_model.dart';
import 'package:link_dance/model/follow_count_model.dart';

import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/model/user_follow_teacher_model.dart';
import 'package:link_dance/model/vo/detail_screen_vo.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/repository/follow_repository.dart';
import 'package:link_dance/repository/movie_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';

class TeacherPageScreen extends StatelessWidget {
  late TeacherModel teacherModel;
  late TeacherRepository teacherRepository;
  late FollowRepository followRepository;
  late ContentGroupRepository contentGroupRepository;
  late Image banner;
  late ScrollController _scrollController;
  late MovieRepository movieRepository;
  int pageSize = 10;
  late ContentUserAcessModel? userAccess;
  UserFollowTeacherModel? userFollowTeacherModel;
  late UserModel userModel;
  late Widget followUnFollowButton;

  bool isRunningQuery = false;

  FollowCountModel? followCount;

  TeacherPageScreen({Key? key}) : super(key: key);

  void _initAtributes(BuildContext context) {
    _scrollController = ScrollController()..addListener(_scrollListener);
    userModel = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    teacherRepository = Provider.of<TeacherRepository>(context, listen: false);
    movieRepository = Provider.of<MovieRepository>(context, listen: false);
    followRepository = Provider.of<FollowRepository>(context, listen: false);
    teacherModel = ModalRoute.of(context)!.settings.arguments as TeacherModel;
  }

  void _initQuerys() {
    followRepository.getFollow(teacherId: teacherModel.id).then((value) {
      userFollowTeacherModel = value;
    });
    movieRepository.listData.clear();

    Future.delayed(Duration.zero, () async {
      isRunningQuery = true;
      movieRepository
          .findByOwnerIdPagination(ownerID: teacherModel.userId, limit: 4)
          .whenComplete(() => isRunningQuery = false);
      followCount =
          await followRepository.getOrCreate(teacherID: teacherModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initAtributes(context);
    _initQuerys();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title:
             Text("Perfil de ${teacherModel.name} ", overflow: TextOverflow.ellipsis),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(children: [
              _getHeaderVo(height: height, width: width),
              Stack(
                children: [
                  Positioned(
                    right: 65,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<FollowRepository>(
                          builder: (context, repository, child) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: _getButtonFollowUnFollowButton(
                              followRepository: followRepository),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10,top: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: _getCountFollow(),
                    ),
                  ),
                  _getPageDetailVo(context),
                ],
              ),
              const Text("Videos"),
              sizedBox15(),
            ]),
          ),
          Consumer<MovieRepository>(builder: (context, repository, child) {
            return _getGridMovieList(repository);
          })
        ],
      ),
    );
  }


  Widget temp() {

    return Row(children: [



    ],);
  }

  SliverGrid _getGridMovieList(repository) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        var data = repository.listData[index];

        return MovieItemListComponent(
          movie: data,
          blocAcess: false,
        );
      }, childCount: repository.listData.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
    );
  }

  Column _getCountFollow() {
    return Column(
      children: [
        Consumer<FollowRepository>(builder: (context, repository, child) {
          return Text(
            repository.followCount == null
                ? "0"
                : repository.followCount!.like.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          );
        }),
        const Text(
          "Seguidores",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        )
      ],
    );
  }

  PageDetailSimpleComponent _getPageDetailVo(BuildContext context) {
    List<Widget>? contacts = [];
    String? whapp;
    String? insta;

    if (teacherModel.contacts != null && teacherModel.contacts!.length > 1) {
      whapp = teacherModel.contacts!['whatsapp'];
      insta = teacherModel.contacts!['instagram'];
      TextStyle style = TextStyle(fontSize: 13);
      const iconSize = 20.0;
      if (whapp != null) {
        contacts.add( const Icon(FontAwesomeIcons.whatsapp,size:  iconSize,));

        contacts.add(sizedBoxH5());
        contacts.add(SelectableText(whapp,style:style  ));
        contacts.add( IconButton( iconSize: iconSize, onPressed: () {
              copyClipboardData(whapp!, context,mensage: "WhatsApp copiado");
        }, icon:Icon (Icons.copy)) );
      }
      if (insta != null) {

        contacts.add(const Icon(FontAwesomeIcons.instagram,size: iconSize,));
        contacts.add(sizedBoxH5());
        contacts.add(SelectableText(insta,style:style));
        contacts.add( IconButton( iconSize: iconSize, onPressed: () {
          copyClipboardData(insta!, context,mensage: "Insta copiado");
        }, icon:Icon (Icons.copy)) );
      }
    }

    return PageDetailSimpleComponent(
        bodyData: PageDetailBodyVo(
            title: teacherModel.name,
            info: contacts,
            subTitle: subtitle(),
            description: teacherModel.description));
  }

  List<Widget> subtitle() {
    TextStyle style = TextStyle(fontSize: 12);
    var danceRhythms=
        teacherModel.danceRhythms;
    List<Widget> textRetrurn = [];
    for (int i=0;i<danceRhythms.length; i++ ) {
          if (i==(danceRhythms.length-1)) {
            textRetrurn.add(Text("${danceRhythms[i]}.",style: style,));
          }else {
            textRetrurn.add(Text("${danceRhythms[i]},",style: style,));
          }
    }


    return textRetrurn;
  }

  PageHeaderComponent _getHeaderVo(
      {required double width, required double height}) {
    return PageHeaderComponent(
        headerData: PageHeaderDetailVo(

            imageBackground: teacherModel.photo ?? Constants.defaultAvatar,
            width: width,
            height: height));
  }

  Widget _getButtonFollowUnFollowButton(
      {required FollowRepository followRepository}) {
    if (userFollowTeacherModel == null ||
        (userFollowTeacherModel != null &&
            userFollowTeacherModel?.status == FollowStatusStatus.unFollow)) {
      return _followUnFollowButton(
          followRepository: followRepository,
          icon: const Icon(FontAwesomeIcons.heart));
    } else {
      return _followUnFollowButton(
          followRepository: followRepository,
          icon: const Icon(FontAwesomeIcons.heartCircleCheck,
              color: Colors.white),
          background: Colors.blue,
          text: Colors.white,
          label: "Seguindo");
    }
  }

  Widget _followUnFollowButton(
      {required FollowRepository followRepository,
      Color background = Colors.white,
      Color text = Colors.blue,
      String label = "Seguir",
      required Icon icon}) {
    return TextButton.icon(
        icon: icon,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(100, 30)),
            shadowColor: MaterialStateProperty.all<Color>(Colors.black),
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: Colors.black))),
            backgroundColor: MaterialStateProperty.all(background)),
        onPressed: () async {
          await followAndUnfollow();
        },
        label: Text(
          label,
          style: TextStyle(color: text),
        ));
  }

  Future<void> followAndUnfollow() async {
    if (userFollowTeacherModel == null ||
        (userFollowTeacherModel != null &&
            userFollowTeacherModel!.id == null)) {
      //nao esta seguindo
      userFollowTeacherModel = UserFollowTeacherModel(
          userId: userModel.id,
          teacherId: teacherModel.id,
          userPhone: userModel.phone ?? "",
          userEmail: userModel.email ?? "",
          status: FollowStatusStatus.follow,
          createDate: Timestamp.now());
      userFollowTeacherModel = await followRepository.followOrUnfollow(
          followVo: userFollowTeacherModel!);
      followRepository.incrementFollow(followCount: followCount!);
    } else if (userFollowTeacherModel!.status == FollowStatusStatus.follow) {
      //se estiver seguindo, deixa de seguir
      userFollowTeacherModel!.status = FollowStatusStatus.unFollow;

      userFollowTeacherModel = await followRepository.followOrUnfollow(
          followVo: userFollowTeacherModel!);
      followRepository.decrementFollow(followCount: followCount!);
    } else {
      //se nao  estiver seguindo, começa a seguir
      userFollowTeacherModel!.status = FollowStatusStatus.follow;
      followRepository.incrementFollow(followCount: followCount!);
      userFollowTeacherModel = await followRepository.followOrUnfollow(
          followVo: userFollowTeacherModel!);
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageSize += 4;
      movieRepository.findByOwnerIdPagination(
          ownerID: teacherModel.userId, nextPage: true, limit: pageSize);
      if (kDebugMode) {
        print("Hora de busca mais itens");
      }
    }
  }
}
