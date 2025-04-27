import 'package:flutter/material.dart';

extension MyTextFieldExt on TextEditingController{
  int toInt(){
    if(text.isEmpty){
      return 0;
    }
    return int.parse(text.trim());
  }

}