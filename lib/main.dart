import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper/full_image.dart';
import 'package:wallpaper/liked.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WallpaperScreen(title: 'Wallpaper'),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  WallpaperScreen({Key key, this.title}) : super(key: key);

  final String title;

  void _onLike(DocumentSnapshot document) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(document.reference);
      await transaction
          .update(freshSnap.reference, {'liked': !freshSnap['liked']});
    });
  }

  @override
  WallpaperScreenState createState() => new WallpaperScreenState();
}

class WallpaperScreenState extends State<WallpaperScreen> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> _wallpaperList;
  final CollectionReference collectionReference =
      Firestore.instance.collection('wallpapers');

  final LinearGradient backgroundGradient = LinearGradient(
      colors: [Color(0x10000000), Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((snapshot) {
      setState(() {
        _wallpaperList = snapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Widget _buildItemList(BuildContext context, DocumentSnapshot document) {
    String imgPath = document.data['url'];
    bool liked = document.data['liked'];
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: InkWell(
              child: Hero(
                tag: imgPath,
                child: FadeInImage(
                  image: NetworkImage(imgPath),
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/imgs/wallfy.png'),
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullImageScreen(imgPath))),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              child: IconButton(
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
                color: liked ? Colors.red : Colors.white,
                onPressed: () => widget._onLike(document),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LikedScreen(likedList: _wallpaperList))),
          ),
        ],
      ),
      body: _wallpaperList != null
          ? StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: _wallpaperList.length,
              itemBuilder: (context, index) =>
                  _buildItemList(context, _wallpaperList[index]),
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
