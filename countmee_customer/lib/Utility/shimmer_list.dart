import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/*
Title : Shimmer List 
Purpose: To get a list in a shimmer effect
Created By : Kalpesh Khandla
Created On : N/A
Last Edited By : 3 Feb 2022
*/

class Shimmer_List_Style extends StatelessWidget {
  int tag;
  Shimmer_List_Style(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.maxFinite,
      width: double.maxFinite,
      child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: _notificationRow(context),
              ),
              itemCount: 6,
            ),
          ),
        ),
      ]),
    );
  }

  _notificationRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.0,
          height: 48.0,
          color: Colors.white,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 11.0,
                    color: Colors.white,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
