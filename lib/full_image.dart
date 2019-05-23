import 'package:flutter/material.dart';

class FullImageScreen extends StatefulWidget {
  FullImageScreen(this.imgPath);

  final String imgPath;
  final LinearGradient backgroundGradient = LinearGradient(
      colors: [Color(0x10000000), Color(0x30000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  @override
  FullImageScreenState createState() => new FullImageScreenState();
}

class FullImageScreenState extends State<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: widget.backgroundGradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: widget.imgPath, child: Image.network(widget.imgPath)),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      elevation: 8.0,
                      backgroundColor: Colors.blue,
                      leading: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
