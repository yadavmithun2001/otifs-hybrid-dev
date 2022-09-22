import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 100,
        child: ProfileShimmer(),
        );
  }
}
