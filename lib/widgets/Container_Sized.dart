import 'package:flutter/material.dart';

class Container_Sized extends StatelessWidget {
  const Container_Sized({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container and SizedBox'),
        backgroundColor: Colors.deepPurple,
      ) ,
      // body: Center(
      //   child: SizedBox(
      //     height: 50,
      //     width: 50,
      //     child: Text('Hello'),
      //   ),
      //
      // ),
      // It is just contains height, width and text . We can use it for spacing between two widgets, blank space between widgets
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.blue,
            //shape: BoxShape.circle
            //borderRadius: BorderRadius.circular(20)
            borderRadius: 
              BorderRadius.only(
                topLeft: Radius.circular(20) , 
                bottomRight: Radius.circular(20)
              ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 5,
                color: Colors.black
              )
            ]
          ),
          child:
            Center(
              // child: Text("Hello",
              //   style: TextStyle(fontSize: 20),
              // ),

              child: Center(
                child: Container(
                  color: Colors.red,
                ),
              ),
            ),


        ),
      )
    );
  }
}
