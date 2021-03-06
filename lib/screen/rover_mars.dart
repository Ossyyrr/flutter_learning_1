import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nasa_app/constant/colors.dart';
import 'package:nasa_app/model/rover_mars_model.dart';
import 'package:nasa_app/repository/rover_mars_repository.dart';
import 'package:nasa_app/screen/rover_mars_detail.dart';
import 'package:nasa_app/widget/clip_path.dart';

final colorBase = PRIMARY_COLOR.withOpacity(.5);

class RoverMars extends StatefulWidget {
  RoverMars({Key key}) : super(key: key);

  @override
  _RoverMarsState createState() => _RoverMarsState();
}

class _RoverMarsState extends State<RoverMars> {
  int columnCount = 2;
  String fetchedDate = '2020-01-10';

  @override
  void initState() {
    super.initState();
  }

  void changeGridCounter(bool suma) {
    setState(() {
      if (suma) {
        if (columnCount < 5) columnCount++;
      } else {
        if (columnCount > 1) columnCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C0C0E),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
          child: FutureBuilder<List<RoverMarsModel>>(
        future: fetchPhotoRovers(fetchedDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var roverItems = snapshot.data;
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 45),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: columnCount,
                        children: List.generate(roverItems.length, (index) {
                          return Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RoverMarsDetail(
                                          roverItemDetailed:
                                              roverItems[index]))),
                              child: Image.network(
                                roverItems[index].imgSrc,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment(0, .5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      gridCounterButtons(false),
                      gridCounterButtons(true)
                    ],
                  ),
                ),
                roverMarsHeader(),
                Align(
                  alignment: Alignment(0, -.8),
                  child: calendar(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(child: CircularProgressIndicator());
        },
      )),
    );
  }

  Widget calendar() {
    return GestureDetector(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: PRIMARY_COLOR,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Icon(Icons.calendar_today_outlined,
              size: 32, color: Color(0xFFf2c902)),
        ),
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2013),
                  lastDate: DateTime.now())
              .then((date) {
            int anoActual = date.year;
            int mesActual = date.month;
            int diaActual = date.day;
            setState(() {
              fetchedDate = '$anoActual-$mesActual-$diaActual';
            });
          });
        });
  }

  Widget gridCounterButtons(bool isRight) {
    return GestureDetector(
        onTap: () => changeGridCounter(isRight),
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
                left: isRight ? 24 : 0,
                right: isRight ? 0 : 24,
                top: 16,
                bottom: 16),
            child: Container(
                alignment:
                    isRight ? Alignment(0.5, -0.05) : Alignment(-0.5, -0.05),
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  color: colorBase,
                  borderRadius: isRight
                      ? BorderRadius.only(
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        )
                      : BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                ),
                child: Text(
                  isRight ? '+' : '-',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFf2c902),
                  ),
                )),
          ),
        ));
  }

  Widget roverMarsHeader() {
    return ClipPath(
      clipper: CustomClipRoverHeader(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: colorBase,
          height: 125,
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Rovers Curiosity',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf2c902)),
                ),
              ),
              Text(
                fetchedDate,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFf2c902)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
