import 'package:flutter/material.dart';
import 'package:linkaty/core/constants/assets_app.dart';

class BgImageWidget extends StatelessWidget {
  const BgImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(AssetsApp.loginBg, fit: BoxFit.cover),
    );
  }
}
