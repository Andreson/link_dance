

import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/model/vo/detail_screen_vo.dart';
import 'package:flutter/material.dart';

class PageDetailSimpleComponent  extends StatelessWidget {

  PageDetailBodyVo bodyData;

  PageDetailSimpleComponent({required this.bodyData });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Column(
        children: [
          if ( bodyData.title.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 220,
              child: Text(
                overflow:TextOverflow.clip ,
                "${bodyData.title} ",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
           if ( bodyData.subTitle!=null)
          Padding(
            padding: EdgeInsets.only(top:5),
            child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 0.55,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Row(
                    children: bodyData.subTitle!,
                  )
                ],
              ),
            ),
          ),
            ),
          ),
          // Row(
          //   children: bodyData.subTitle
          // ),
          sizedBox10(),
          if(bodyData.info!=null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bodyData.info!.isNotEmpty ? bodyData.info!:[Text("")]   ,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              textAlign: TextAlign.justify,
              style: const TextStyle(

                  fontSize: 12, color: Colors.white),
              "${bodyData.description} ${bodyData.description} ${bodyData.description} ${bodyData.description} ${bodyData.description} ${bodyData.description}" ,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }





}