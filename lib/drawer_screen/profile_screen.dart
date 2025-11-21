// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../authentication_page/sign_in_page.dart';
// import 'edit_profile_screen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(), // bounce active
//         slivers: [
//           // SLIVER APPBAR
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             pinned: true,
//             expandedHeight: MediaQuery.of(context).size.height * 0.2,
//             backgroundColor: Colors.grey.shade900,
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: const Text(
//                 "Profile",
//                 style: TextStyle(color: Colors.white),
//               ),
//               background: Container(
//                 color: Colors.blueGrey.shade700,
//                 child: const Center(
//                   child: Icon(Icons.person, color: Colors.white, size: 90),
//                 ),
//               ),
//             ),
//           ),
//
//           // PROFILE CONTENT
//           SliverFillRemaining(
//             // hasScrollBody: true, // <--- FORCE SCROLL
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(color: Colors.amber),
//                   );
//                 }
//
//                 var data = snapshot.data!.data() ?? {};
//
//                 return SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Name: ${data['name']}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//
//                       Text(
//                         "Email: ${data['email']}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       Text(
//                         "Phone: ${data['phone']}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       Text(
//                         "Bio: ${data['bio']}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//
//                       const SizedBox(height: 30),
//
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditProfileScreen(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.amber,
//                           ),
//                           child: const Text(
//                             "Edit Profile",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             await FirebaseAuth.instance.signOut();
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const SignInPage(),
//                               ),
//                               (route) => false,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           child: const Text(
//                             "Logout",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//
//                       // const SizedBox(height: 200),
//                       // EXTRA HEIGHT FOR SMOOTH SCROLL
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authentication_page/sign_in_page.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // SLIVER APPBAR
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            backgroundColor: Colors.grey.shade900,

            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                color: Colors.blueGrey.shade700,
                child: const Center(
                  child: Icon(Icons.person, color: Colors.white, size: 90),
                ),
              ),
            ),
          ),

          // PROFILE SCREEN CONTENT
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    ),
                  );
                }

                var data = snapshot.data!.data() ?? {};

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Name: ${data['name']}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        "Email: ${data['email']}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        "Phone: ${data['phone']}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        "Bio: ${data['bio']}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInPage(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 2500), // For smooth bounce end
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
