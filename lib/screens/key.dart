import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class KeyCarousel extends StatefulWidget {
  // final DateTime quizDate;
  final List myData;
  final String subName;
  KeyCarousel({@required this.myData,@required this.subName}) : super();

  final String title = "Carousel Demo";

  @override
  KeyCarouselState createState() => KeyCarouselState();
}

class KeyCarouselState extends State<KeyCarousel> {
  //
  CarouselSlider carouselSlider;
  int _current = 0;
  String answer;
 

 

  @override
  Widget build(BuildContext context) {
    print(widget.myData);
    print("inside");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subName),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            carouselSlider = CarouselSlider(
              height: 400.0,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: false,
              reverse: false,
              enableInfiniteScroll: false,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _current = index;
                });
              },
              items: widget.myData.map((questionn) {
                print(questionn['correct_option']);
                 
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Column(children: <Widget>[
Text('Question'+':  '+questionn['question'],style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontFamily: "Quando",
                            fontWeight: FontWeight.w700,),),
                            SizedBox(height: 60,),
                            Text('Answer'+':  '+questionn['opt'+questionn['correct_option'][questionn['correct_option'].length-1]],style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor,fontFamily: "Quando",
                            fontWeight: FontWeight.w700,),),
                        ],) 
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: goToPrevious,
                  child: Text("<"),
                ),
                OutlineButton(
                  onPressed: goToNext,
                  child: Text(">"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}