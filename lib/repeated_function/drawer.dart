import 'package:flutter/material.dart';

class DrawerFunction extends StatefulWidget {
  const DrawerFunction({super.key});

  @override
  State<DrawerFunction> createState() => _DrawerFunctionState();
}

class _DrawerFunctionState extends State<DrawerFunction> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Empty circle (later replace with image)
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.white),
              title: Text('Favorite', style: TextStyle(color: Colors.white)),
            ),
            // ListTile(
            //   leading: Icon(Icons.menu_book, color: Colors.white),
            //   title: Text('Blog', style: TextStyle(color: Colors.white)),
            // ),
            ListTile(
              leading: Icon(Icons.web, color: Colors.white),
              title: Text('Website', style: TextStyle(color: Colors.white)),
            ),
            // ListTile(
            //   leading: Icon(Icons.subscriptions, color: Colors.white),
            //   title: Text('Subscribe', style: TextStyle(color: Colors.white)),
            // ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('About', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
