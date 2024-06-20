import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solnext/core/constants/dimensions.dart';


class CustomShimmerAnimation extends StatelessWidget {
  const CustomShimmerAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getScreenWidth(context) * 0.6,
        height: getScreenWidth(context) * 0.2,
        child: Shimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white
              ),
            ),
            gradient: LinearGradient(
              colors: [Color(0xffffffff), Color.fromARGB(255, 214, 214, 214)],
              stops: [0, 0.5],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )));
  }
}
