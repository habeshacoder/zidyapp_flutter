import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:zigyapp/provider/auth.dart';
import 'package:zigyapp/provider/created_user_provider.dart';
import 'package:zigyapp/provider/page_two_users_provider.dart';
import 'package:zigyapp/widget/create_user_widget.dart';
import 'package:zigyapp/widget/created_user.dart';
import 'package:zigyapp/widget/page_two_users_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var isinit = true;
  var isLoading = false;
  void showalert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('an error occured'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('okay'),
            )
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      setState(() {
        isLoading = true;
      });
      try {
        Provider.of<PageTwoUsersProvider>(context).fectAndPut().then((_) {
          setState(() {
            isLoading = false;
          });
        });
      } catch (error) {
        showalert('${error}');
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }
  bool isUserCreated=false;
  void switchIsUserCreated(){
           setState(() {
             isUserCreated=true;
           });
  } 

  @override
  Widget build(BuildContext context) {
    final loadedUsers =
        Provider.of<PageTwoUsersProvider>(context).pageTwoUsersList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00A19A),
        title: Text(
          'Manage Your Data',
          style: TextStyle(
              color: Colors.white, fontSize: 23, fontFamily: 'Open Sans'),
        ),
        actions: [
           InkWell(
            onTap:  Provider.of<Auth>(context).logOut,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: Text('Log Out')))],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: CreateUserWidget(),
            ),
            Container(
              margin: EdgeInsets.only(top: 13),
              height: 200,
              child: Consumer<CreatedUserProvider>(
                builder: (context, createdUserProvider, child) =>
                    ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: createdUserProvider.createdUsersList.length,
                  itemBuilder: (context, index) => CreatedUser(
                    createdUser: createdUserProvider.createdUsersList[index],
                  ),
                ),
              ),
            ),
          if(isLoading)CircularProgressIndicator(),
          if(!isLoading)  GridView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3/ 6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: loadedUsers.length,
              itemBuilder: (context, index) =>
                  PageTwoUserWidget(loadedUser: loadedUsers[index]),
              // itemCount: ,
              // itemBuilder: (context, index) => PageTwoUserWidget(
              //   loadedUser: loadedUsers[index],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
