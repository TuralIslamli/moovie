import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

List<String> posterList = [
  "assets/posters/joker.jpg",
  "assets/posters/batman.jpg",
  "assets/posters/fight-club.jpg",
  "assets/posters/got.jpeg",
  "assets/posters/hp.jpg",
  "assets/posters/spiderman.jpg",
  "assets/posters/oppenheimer.jpg",
  "assets/posters/pianist.jpg",
  "assets/posters/lcdp.jpg",
  "assets/posters/taxi.jpg",
  "assets/posters/the-godfather.jpg",
  "assets/posters/barbie.jpg",
];

String apiKey = "?api_key=bf4dd24829a3b207af916dda82f17151";

Future<File> getImageFileFromAssets() async {
  final byteData = await rootBundle.load('assets/default-avatar.png');

  final file =
      File('${(await getTemporaryDirectory()).path}/default-avatar.png');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
