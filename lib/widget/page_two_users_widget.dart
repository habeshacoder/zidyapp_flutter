import 'package:flutter/material.dart';

class PageTwoUserWidget extends StatelessWidget {
  PageTwoUserWidget({required this.loadedUser});
  final loadedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7, left: 7),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 200,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            child: Center(
              child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage('${loadedUser.avatar}')),
            ),
          ),
          Text('${loadedUser.firstName}'),
          SizedBox(
            height: 5,
          ),
          Text('${loadedUser.lastName}'),
          SizedBox(
            height: 5,
          ),
          Text('${loadedUser.email}'),
        ],
      ),
    );
  }
}
