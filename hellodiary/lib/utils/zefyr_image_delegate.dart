import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hellodiary/bloc/index.dart';

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {

  BuildContext context;
  MyAppZefyrImageDelegate(this.context);

  @override
  Widget buildImage(BuildContext context, String imageSource) {
    final file = File(imageSource);
    return Container(
      width: double.infinity,
      child: Image.file(
        file,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  @override
  Future<String> pickImage(ImageSource source) async {
    DiaryBloc bloc = BlocProvider.of(context);
    bloc.showPicker = true;
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    // We simply return the absolute path to selected file.
    bloc.showPicker = false;
    return file.path;
  }
}
