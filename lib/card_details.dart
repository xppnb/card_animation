import 'package:card_animation/card_3d.dart';
import 'package:card_animation/main.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatefulWidget {
  final Card3D card;

  const CardDetails({Key key, this.card}) : super(key: key);

  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Hero(
            tag: widget.card.title,
            child: Align(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Card3DWidget(
                  image: widget.card.image,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(widget.card.title,
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.card.author,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
