import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreatedUser extends StatelessWidget {
  CreatedUser({required this.createdUser});
  final createdUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 7,left: 7),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 200,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: Center(
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/createduserimage.png')),
            ),
          ),
          Text('${createdUser.name}'),
          SizedBox(
            height: 5,
          ),
          Text('${createdUser.job}'),
          SizedBox(
            height: 5,
          ),
          Text('${createdUser.createdAt}'),
        ],
      ),
    );
  }
}
