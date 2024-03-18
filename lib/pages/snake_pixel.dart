import 'package:flutter/material.dart';

class SnakePixel extends StatelessWidget {
    const SnakePixel({ super.key});
    @override
    Widget build(BuildContext context){
        return Padding(
            padding:const EdgeInsets.all(2.0),
            child:Container(
                decoration:BoxDecoration(
                    color:const Color.fromARGB(255, 4, 123, 8),
                    borderRadius:BorderRadius.circular(5),

                ),
            ),
        );
    }
}