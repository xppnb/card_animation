import 'dart:math';
import 'dart:ui';

import 'package:card_animation/card_3d.dart';
import 'package:card_animation/card_details.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "PastList",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        leading: Icon(Icons.menu),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CardBody(),
              flex: 3,
            ),
            Expanded(
              child: CardHorizontal(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class CardBody extends StatefulWidget {
  const CardBody({Key key}) : super(key: key);

  @override
  _CardBodyState createState() => _CardBodyState();
}

class _CardBodyState extends State<CardBody> with TickerProviderStateMixin {
  bool _selectedModel = false;
  AnimationController _animationControllerSelection;
  AnimationController _animationControllerMovement;
  int selectedIndex = 0;

  Future<void> _onCardSelected(Card3D card, int index) async {
    setState(() {
      selectedIndex = index;
    });
    _animationControllerMovement.forward();
    final duration = Duration(milliseconds: 750);
    await Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, _) {
              return FadeTransition(
                opacity: animation,
                child: CardDetails(
                  card: card,
                ),
              );
            },
            transitionDuration: duration));
    _animationControllerMovement.reverse(from: 1.0);
  }

  int _getCurrentFactor(int currentIndex) {
    if (selectedIndex == null || selectedIndex == currentIndex) {
      return 0;
    } else if (currentIndex > selectedIndex) {
      return -1;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    _animationControllerSelection = AnimationController(
        vsync: this,
        lowerBound: 0.15,
        upperBound: 0.4,
        duration: Duration(milliseconds: 500));

    _animationControllerMovement =
        AnimationController(vsync: this, duration: Duration(milliseconds: 880));
  }

  @override
  void dispose() {
    _animationControllerSelection.dispose();
    _animationControllerMovement.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
          animation: _animationControllerSelection,
          builder: (context, snapshot) {
            final selectionValue = _animationControllerSelection.value;
            return GestureDetector(
              onTap: () {
                if (!_selectedModel) {
                  _animationControllerSelection.forward().whenComplete(() {
                    _selectedModel = true;
                  });
                } else {
                  _animationControllerSelection.reverse().whenComplete(() {
                    _selectedModel = false;
                  });
                }
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(selectionValue),
                child: AbsorbPointer(
                  absorbing: !_selectedModel,
                  child: Container(
                    width: 230,
                    height: constraints.maxHeight,
                    color: Colors.white,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(
                          cardList.length,
                          (index) => Card3DItem(
                                card: cardList[index],
                                height: constraints.maxHeight / 2,
                                percent: selectionValue,
                                dept: index.toDouble(),
                                onCardSelected: (card) {
                                  _onCardSelected(card, index);
                                },
                                verticalFactor: _getCurrentFactor(index),
                                animation: _animationControllerMovement,
                              )).reversed.toList(),
                      // Positioned(
                      //   bottom: 0,
                      //   left: 0,
                      //   right: 0,
                      //   child: Slider(
                      //       value: _value,
                      //       min: 0.15,
                      //       max: 0.4,
                      //       onChanged: (val) {
                      //         setState(() {
                      //           _value = val;
                      //         });
                      //       }),
                      // )
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

class Card3DItem extends AnimatedWidget {
  final Card3D card;
  final double height;
  final double percent;
  final double dept;
  final ValueChanged<Card3D> onCardSelected;
  final int verticalFactor;

  const Card3DItem(
      {Key key,
      this.card,
      this.height,
      this.percent,
      this.dept,
      this.onCardSelected,
      this.verticalFactor = 0,
      Animation<double> animation})
      : super(key: key, listenable: animation);

  Animation<double> get animation => listenable;

  @override
  Widget build(BuildContext context) {
    final depthFactor = 50;
    final bottomMargin = height / 4;
    return Positioned(
      top: height + -dept * height / 2.0 * percent - bottomMargin,
      left: 0,
      right: 0,
      child: Opacity(
        // opacity: verticalFactor == 0 ? 1.0 : 1 - animation.value,
        opacity: 1.0,
        child: Hero(
          tag: card.title,
          flightShuttleBuilder: (context, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            Widget _current;
            if (flightDirection == HeroFlightDirection.push) {
              _current = toHeroContext.widget;
            } else {
              _current = fromHeroContext.widget;
            }
            return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final newValue = lerpDouble(0.0, 2 * pi, animation.value);
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(newValue),
                    child: _current,
                  );
                });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                  0.0,
                  verticalFactor *
                      animation.value *
                      MediaQuery.of(context).size.height,
                  dept * depthFactor),
            child: GestureDetector(
              onTap: () {
                print('TOUCH');
                onCardSelected(card);
              },
              child: SizedBox(
                height: height,
                child: Card3DWidget(
                  image: card.image,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardHorizontal extends StatelessWidget {
  const CardHorizontal({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(12), child: Text("Recently Played")),
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Card3DWidget(
                image: cardList[index].image,
              ),
            );
          },
          itemCount: cardList.length,
        ))
      ],
    );
  }
}

class Card3DWidget extends StatelessWidget {
  final String image;

  const Card3DWidget({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius border = BorderRadius.circular(15);
    return PhysicalModel(
      elevation: 10,
      borderRadius: border,
      color: Colors.white,
      child: ClipRRect(
        borderRadius: border,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          width: 230,
        ),
      ),
    );
  }
}
