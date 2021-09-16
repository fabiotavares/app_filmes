import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin LoaderMixin on GetxController {
  // adicionando listener para loader
  void loaderListener(RxBool loaderRx) {
    // usando o conceito de works (trabalhadores) do get, semelhantes às actions do mobix
    ever<bool>(loaderRx, (loading) async {
      if (loading) {
        // exibir o loader
        await Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
      } else {
        // fehcando o dialog de cima
        Get.back();
      }
    });
  }
}
