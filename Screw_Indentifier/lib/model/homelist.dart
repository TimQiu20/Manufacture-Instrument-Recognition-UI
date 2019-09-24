import 'package:best_flutter_ui_templates/album/albumScreen.dart';
import 'package:best_flutter_ui_templates/history/historyScreen.dart';
import 'package:best_flutter_ui_templates/takephoto/takephotoScreen.dart';
import 'package:best_flutter_ui_templates/userInfo/userInfoScreen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  Widget navigateScreen;
  String imagePath;

  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  static List<HomeList> homeList = [
    HomeList(
      imagePath: "assets/take_photo/takephotoIcon.png",
      navigateScreen: Takephotocreen(),
    ),
    HomeList(
      imagePath: "assets/album/albumIcon.png",
      navigateScreen: AlbumScreen(),
    ),
    HomeList(
      imagePath: "assets/history/historyIcon.png",
      navigateScreen: HistoryScreen(),
    ),
    HomeList(
      imagePath: "assets/user_info/userInfoIcon.png",
      navigateScreen: UserInfoScreen(),
    )
  ];
}
