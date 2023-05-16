import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
//import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

const firebaseConfig = {
  'webClientId': '396288866791-sas69upgvkm840eps3ijv4lf962hb9r9.apps.googleusercontent.com',
  'storageBucket': 'gs://outdoorsman-781a7.appspot.com/',
};

class _CurrentUser {
  String? displayName;
  String? email;
  String? photoUrl;

  _CurrentUser({
    this.displayName,
    this.email,
    this.photoUrl,
  });
}

_CurrentUser _currentUser = _CurrentUser();


Future<void> main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDQCWrdSEpej1s3vpr9fzE_sykA4C2kfOs",
      authDomain: "outdoorsman-781a7.firebaseapp.com",
      projectId: "outdoorsman-781a7",
      storageBucket: "outdoorsman-781a7.appspot.com",
      messagingSenderId: "396288866791",
      appId: "1:396288866791:web:7bfa6d0b83bc73c0ab2542",
      measurementId: "G-9GP2Y6C62T"
    ),
  );

  runApp(const MyApp());
}

//FirebaseStorage storage = FirebaseStorage.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = "Outdoorsman's Compass";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
} 

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
} 


class _MyHomePageState extends State<MyHomePage> {
  String? uName;

  Future<void> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = userCredential.user!;
     
    _currentUser = _CurrentUser(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    setState(() {
      uName = _currentUser.displayName;
    });

    print("Saved User Data:");
    print(_currentUser.displayName);
    print(_currentUser.email);

  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _currentUser = _CurrentUser();

    setState(() {
        uName = _currentUser.displayName;
    });
    
  } catch (e) {
    print('Error signing out: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF1B5E20),
        centerTitle: true,
        actions: [
          if (_currentUser.email == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => signInWithGoogle(),
                child: Text('Sign In'),
              ),
            ),
          if (_currentUser.email != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Signed in as ${uName}'),
            ),
          if (_currentUser.email != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => signOut(),
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('outdoors2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                height: 150,
                //color: Colors.lightGreen[600],
                decoration: BoxDecoration(
                  color: Colors.lightGreen[600],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: Text(
                    'Welcome To Outdoorsman\'s Compass!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 600,
                  height: 250,
                  //color: Colors.lightGreen[700],
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[600],
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                    child: Text(
                      'Our mission is to create a community-driven platform where users can share their encounters with wildlife, allowing us to build a database of information for all to access. Whether you\'re a wildlife biologist, a hunter, or simply an outdoor enthusiast, we invite you to join us in our mission to document and learn about the incredible animals we share this planet with. Together, we can create a virtual community that not only celebrates our encounters with wildlife, but also helps us better understand and protect the natural world around us.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Navigation'),
            ),
            ListTile(
              title: const Text('User Profile'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },
            ),
            ListTile(
              title: const Text('Messages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdRoute()),
                );
              },
            ),
            ListTile(
              title: const Text('Map'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FourthRoute()),
                );
              },
            ),
            ListTile(
              title: const Text('Create Post'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FifthRoute()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Post {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final Timestamp clock;
  final String? pictureUrl;

  Post({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.clock,
    this.pictureUrl,
  });

  factory Post.fromData(Map<String, dynamic> data) {
    return Post(
      title: data['title'],
      description: data['description'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      pictureUrl: data['pictureUrl'],
      clock: data['dateTime'],
    );
  }
}

//------------
//User Profile
//||||||||||||
//vvvvvvvvvvvv
class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondState();
}

class _SecondState extends State<SecondRoute> {
  String? uName;
  String? uEmail;
  late List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
    if (_currentUser.email == null) {
      signInWithGoogle();
    } else {
      uName = _currentUser.displayName;
      uEmail = _currentUser.email;
    }
  }

  Future<void> fetchPosts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('email', isEqualTo: uEmail)
        .get();
    final postsData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      posts = postsData.map((postData) => Post.fromData(postData)).toList();
    });
  }

  Future<void> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = userCredential.user!;
     
    _currentUser = _CurrentUser(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    setState(() {
        uName = _currentUser.displayName;
        uEmail = _currentUser.email;
    });

    print("Saved User Data:");
    print(_currentUser.displayName);
    print(_currentUser.email);

  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _currentUser = _CurrentUser();

    setState(() {
        uName = _currentUser.displayName;
    });
    
  } catch (e) {
    print('Error signing out: $e');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My Posts'),
      backgroundColor: const Color(0xFF1B5E20),
      centerTitle: true,
      actions: [
        if (_currentUser.email == null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => signInWithGoogle(),
              child: const Text('Sign In'),
            ),
          ),
        if (_currentUser.email != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Signed in as $uName'),
          ),
        if (_currentUser.email != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => signOut(),
              child: const Text('Sign Out'),
            ),
          ),
      ],
    ),
    body: posts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  title: Text(posts[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(posts[index].description),
                      Row(
                        children: [
                          Text(
                            'Latitude: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(posts[index].latitude.toString()),
                          SizedBox(width: 10),
                          Text(
                            'Longitude: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(posts[index].longitude.toString()),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Posted: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(DateFormat('yyyy-MM-dd hh:mm a').format(posts[index].clock.toDate())),
                        ],
                      ),
                    ],
                  ),
                  leading: posts[index].pictureUrl == null
                      ? null
                      : CircleAvatar(
                          backgroundImage: NetworkImage(posts[index].pictureUrl!),
                        ),
                ),
              );
            },
        ),
    );
  }
}


//-----------
//  Messages
//|||||||||||
//vvvvvvvvvvv
class ThirdRoute extends StatefulWidget {
  const ThirdRoute({super.key});

  @override
  State<ThirdRoute> createState() => _ThirdState();
}

class _ThirdState extends State<ThirdRoute> {
  String? uName;

  @override
  void initState() {
    super.initState();
    if (_currentUser.email == null) {
      signInWithGoogle();
    } else {
      uName = _currentUser.displayName;
    }
  }

  Future<void> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = userCredential.user!;
     
    _currentUser = _CurrentUser(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    setState(() {
        uName = _currentUser.displayName;
    });

    print("Saved User Data:");
    print(_currentUser.displayName);
    print(_currentUser.email);

  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _currentUser = _CurrentUser();

    setState(() {
        uName = _currentUser.displayName;
    });
    
  } catch (e) {
    print('Error signing out: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Messages"),
          backgroundColor: Color(0xFF1B5E20),
          centerTitle: true,
          actions: [
            if (_currentUser.email == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => signInWithGoogle(),
                  child: Text('Sign In'),
                ),
              ),
            if (_currentUser.email != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Signed in as ${uName}'),
              ),
            if (_currentUser.email != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => signOut(),
                  child: Text('Sign Out'),
                ),
              ),
          ],
        ),
      ),
   );
     body: null;
  }
}

class CustomMarker extends StatelessWidget {
  final String animal;
  final String? description;
  final LatLng position;
  final String? email;
  final String? name;
  final String? picture;

  CustomMarker({
    required this.animal,
    this.description,
    required this.position,
    this.email,
    this.name,
    this.picture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(Icons.location_on),
    );
  } 

  Marker toMarker() {
    return Marker(
      markerId: MarkerId(animal),
      position: position,
      infoWindow: InfoWindow(
        title: animal,
        snippet: description,
      ),
    );
  }
}

//-----------
//    Map
//|||||||||||
//vvvvvvvvvvv
class FourthRoute extends StatefulWidget {
  const FourthRoute({Key? key}) : super(key: key);

  @override
  State<FourthRoute> createState() => _FourthState();
}

class _FourthState extends State<FourthRoute> {
  late GoogleMapController mapController;
  String? uName;
  LatLng? user_position;
  final Set<Marker> cmarkers = {}; 

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    if (_currentUser.email == null) {
      signInWithGoogle();
    } else {
      uName = _currentUser.displayName;
    }
  }

  Future<void> getMarkers() async {
  if(user_position != null){
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    documents.forEach((doc) {
      print(doc['title']);
      setState(() {
        cmarkers.add(
          CustomMarker(
            animal: doc['title'],
            description: doc['description'],
            name: doc['username'],
            email: doc['email'],
            position: LatLng(
              doc['latitude'],
              doc['longitude'],
            ),
            picture: doc['pictureUrl'],
          ).toMarker(),
      );
      });
    });
  }
} 

  Future<void> _getCurrentPosition() async {
    try {
      Position curpos = await Geolocator.getCurrentPosition();
      setState(() {
        user_position = LatLng(curpos.latitude, curpos.longitude);
        //Add Current location to map.
        cmarkers.add(
          CustomMarker(
            animal: "Your Current Location",
            position: LatLng(curpos.latitude, curpos.longitude),
          ).toMarker(),
      );
        getMarkers();
      });
    } catch (e) {
      print('Error getting current position: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = userCredential.user!;
     
    _currentUser = _CurrentUser(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    setState(() {
        uName = _currentUser.displayName;
    });

    print("Saved User Data:");
    print(_currentUser.displayName);
    print(_currentUser.email);

  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _currentUser = _CurrentUser();

    setState(() {
        uName = _currentUser.displayName;
    });
    
  } catch (e) {
    print('Error signing out: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Map"),
          backgroundColor: Color(0xFF1B5E20),
          centerTitle: true,
          actions: [
            if (_currentUser.email == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => signInWithGoogle(),
                  child: Text('Sign In'),
                ),
              ),
            if (_currentUser.email != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Signed in as ${uName}'),
              ),
            if (_currentUser.email != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => signOut(),
                  child: Text('Sign Out'),
                ),
              ),
          ],
        ),
        body: user_position == null ? Center(child: CircularProgressIndicator()) : GoogleMap(
          markers: cmarkers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: user_position ?? LatLng(0,0),
            zoom: 15,
          ),
        ),
      ),
    );
  }
}

//-----------
//Create Post
//|||||||||||
//vvvvvvvvvvv
class FifthRoute extends StatefulWidget {
  const FifthRoute({Key? key}) : super(key: key);

  @override
  _FifthRouteState createState() => _FifthRouteState();
}

class _FifthRouteState extends State<FifthRoute> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  String? _image;
  String? uName;

  Future<void> saveFormData() async {
  final latitude = double.tryParse(_latitudeController.text);
  final longitude = double.tryParse(_longitudeController.text);
  final now = DateTime.now();

  Map<String, dynamic> postData = {
    'username': _currentUser.displayName,
    'email': _currentUser.email,
    'title': _nameController.text,
    'description': _descriptionController.text,
    'latitude': latitude,
    'longitude': longitude,
    'pictureUrl': _image,
    'dateTime': now,
  };

  await FirebaseFirestore.instance.collection('posts').add(postData);
} 
  
Future<void> signInWithGoogle() async {
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  try {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = userCredential.user!;
     
    _currentUser = _CurrentUser(
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );

    setState(() {
        uName = _currentUser.displayName;
    });

    print("Saved User Data:");
    print(_currentUser.displayName);
    print(_currentUser.email);

  } catch (e) {
    print('Error signing in with Google: $e');
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _currentUser = _CurrentUser();

    setState(() {
        uName = _currentUser.displayName;
    });
    
  } catch (e) {
    print('Error signing out: $e');
  }
}

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile?.path;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_currentUser.email == null) {
      signInWithGoogle();
    } else{
      uName = _currentUser.displayName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Post"),
          backgroundColor: const Color(0xFF1B5E20),
          centerTitle: true,
          actions: [
            if (_currentUser.email == null)
              Padding(
                padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => signInWithGoogle(),
                child: Text('Sign In'),
              ),
            ),
          if (_currentUser.email != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Signed in as ${uName}'),
            ),
          if (_currentUser.email != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => signOut(),
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "What Animal Did You See?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 800,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the name of the animal",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the animal name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Upload Optional Picture/Image",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _getImage,
                  child: const Text("Upload Image"),
                ),
                if (_image != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 800,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the description about the animal",
                    ),
                    controller: _descriptionController,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the animal description";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: const SizedBox(width: 200),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16.0),
                          const Text(
                            "Latitude",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 500,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter latitude",
                              ),
                              controller: _latitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the latitude";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16.0),
                          const Text(
                            "Longitude",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 500,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter longitude",
                              ),
                              controller: _longitudeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter the longitude";
                                }
                              }, 
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: const SizedBox(width: 200),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: const SizedBox(width: 200),
                    ),
                    Expanded(
                      child: SizedBox( 
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          Position position = await Geolocator.getCurrentPosition();
                          _latitudeController.text = position.latitude.toString();
                          _longitudeController.text = position.longitude.toString();
                        },
                        child: const Text("Use Current Location"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentUser.email == null){
                            signInWithGoogle();
                          }
                          else {
                            if (_formKey.currentState!.validate()) {
                            // Handle form
                            saveFormData();

                            //Reset variables
                            _nameController.clear();
                            _descriptionController.clear();
                            _latitudeController.clear();
                            _longitudeController.clear();
                            setState(() => _image = null);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Post successfully created"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                          }
                        },
                        child: const Text("Create Post"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: const SizedBox(width: 200),
                  ),
                ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}