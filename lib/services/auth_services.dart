// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   static Future<String> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount googleSignInAccount =
//           await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential authResult =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       final User user = authResult.user;
//       assert(!user.isAnonymous);

//       final User currentUser = FirebaseAuth.instance.currentUser;
//       assert(user.uid == currentUser.uid);
//       await addUserToFirebase(uid: user.uid, email: user.email);
//       await updateUserInFirebase(
//         uid: user.uid,
//         imageUrl: user.photoURL,
//         phoneNumber: user.phoneNumber,
//         userName: user.displayName,
//       );
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     } catch (e) {
//       String errorText;
//       if (e.toString().contains(
//           "NoSuchMethodError: The getter 'authentication' was called on null.")) {
//         errorText = 'Sign In Cancelled By User';
//       } else if (e.toString().contains('network_error')) {
//         errorText = 'Please check your network connection.';
//       }
//       return errorText;
//     }
//   }

//   static Future<void> signOutGoogle() async {
//     await GoogleSignIn().signOut();
//   }
// }
