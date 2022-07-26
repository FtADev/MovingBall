import 'dart:async';
import 'dart:math';

import 'package:fidibo_test/urls.dart';
import 'package:flutter/material.dart';

class BallScreen extends StatefulWidget {
  const BallScreen({Key? key}) : super(key: key);

  @override
  State<BallScreen> createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen> {
  final double _squareSize = 70;
  Offset? _squarePosition;
  double _slope = 0;
  double _xDistance = 0;
  int _tapCount = 0;
  String url = urls[0];

  void moveRight(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel(); //Stop moving in this direction when the screen is tapped again
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _squarePosition = Offset(_squarePosition!.dx + _xDistance,
            _squarePosition!.dy - slope * _xDistance);
      });

      //if the ball bounces off the top or bottom
      if (_squarePosition!.dy < 0 ||
          _squarePosition!.dy >
              MediaQuery.of(context).size.height - _squareSize) {
        timer.cancel();
        moveRight(-slope, i);
      }

      //if the ball bounces off the right
      if (_squarePosition!.dx >
          MediaQuery.of(context).size.width - _squareSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
    });
  }

  void moveLeft(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel(); //Stop moving in this direction when the screen is tapped again
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _squarePosition = Offset(_squarePosition!.dx - _xDistance,
            _squarePosition!.dy + slope * _xDistance);
      });

      //if the ball bounces off the top or bottom
      if (_squarePosition!.dy < 0 ||
          _squarePosition!.dy >
              MediaQuery.of(context).size.height - _squareSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }

      //if the ball bounces off the left
      if (_squarePosition!.dx < 0) {
        timer.cancel();
        moveRight(-slope, i);
      }
    });
  }

  void changePhoto() {
    var rng = Random();
    int index = rng.nextInt(5);
    setState(() {
      url = urls[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    _squarePosition ??= Offset(
        (MediaQuery.of(context).size.width - _squareSize) / 2,
        (MediaQuery.of(context).size.height - _squareSize) / 2);

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                _tapCount++;
                _slope = (-details.delta.dy + _squarePosition!.dy) /
                    (details.delta.dx - _squarePosition!.dx);
                if (details.delta.dx < 0 || details.delta.dy < 0) {
                  moveLeft(_slope, _tapCount);
                }
                if (details.delta.dx > 0 || details.delta.dy > 0) {
                  moveRight(_slope, _tapCount);
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: _squarePosition!.dx,
              top: _squarePosition!.dy,
              child: GestureDetector(
                onTap: changePhoto,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  height: _squareSize,
                  width: _squareSize,
                  child: Image.network(url, fit: BoxFit.fill, loadingBuilder:
                      (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
