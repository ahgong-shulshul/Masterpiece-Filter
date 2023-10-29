import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './camera.dart';

final List<Image> filters = <Image>[Image.asset("assets/tmp5.png", fit: BoxFit.fill,),
  Image.asset("assets/splash.png", fit: BoxFit.fill,),
  Image.asset("assets/tmp2.png", fit: BoxFit.fill,),
  Image.asset("assets/tmp4.png", fit: BoxFit.fill,),
  Image.asset("assets/tmp1.png", fit: BoxFit.fill,),
  Image.asset("assets/splash.png", fit: BoxFit.fill,),
  Image.asset("assets/tmp3.png", fit: BoxFit.fill,),
  Image.asset("assets/tmp4.png", fit: BoxFit.fill,)];

Widget listview_builder(){
  return ListView.builder(
    scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(2),
      itemCount: filters.length,
      itemBuilder: (BuildContext context, int index){
        return InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.0), // 원하는 둥근 정도 설정
              child: Container(
                child: filters[index],
                width: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(4),
                ),
            ),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(index.toString() + " is selected"),),
            )
        );
      },
    );
}
