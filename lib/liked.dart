import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LikedScreen extends StatelessWidget {
  LikedScreen({this.likedList});

  List<DocumentSnapshot> likedList;
  List<DocumentSnapshot> wallpaperLikedList;

  Widget _buildItemList(BuildContext context, DocumentSnapshot document) {
    String imgPath = document['url'];
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: InkWell(
        child: Hero(
          tag: imgPath,
          child: FadeInImage(
            image: NetworkImage(imgPath),
            fit: BoxFit.cover,
            placeholder: AssetImage("assets/imgs/wallfy.png"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    wallpaperLikedList = likedList.where((i) => i.data['liked']).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Images'),
      ),
      body: wallpaperLikedList != null
          ? StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: wallpaperLikedList.length,
              itemBuilder: (context, index) =>
                  _buildItemList(context, wallpaperLikedList[index]),
              staggeredTileBuilder: (index) =>
                  StaggeredTile.count(2, index.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
