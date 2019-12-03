import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'takephotoTheme.dart';
import 'package:camera/camera.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:best_flutter_ui_templates/notificationHandler.dart';
import 'package:url_launcher/url_launcher.dart';

//String _token;

/// Widget to capture and crop the image
class Takephotocreen extends StatefulWidget {
  createState() => _TakephotocreenState();
}

class _TakephotocreenState extends State<Takephotocreen> {

  NotificationHandler _handler;
  StreamSubscription _streamSubscription;
  String _token;
  double _length;
  double _pitch;

  @override
  void initState() {
    super.initState();
    _handler = new NotificationHandler();
    _handler.setUpFirebase().then((token) {
      setState(() {
        _token = token;
      });
    });
    _streamSubscription = _handler.changeNotifier.stream.listen((_) {
      print("lol");
      setState(() {
        _length = _handler.length;
        _pitch = _handler.pitch;
      });
    });
  }

  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        // toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It'
      );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_token == null) {
      return Scaffold(
        body: Center(
          child: new Text(
            "Loading...",
            textAlign: TextAlign.center,
          ),
        )
      );
    }
    else if (_length != null && _pitch != null) {
      double roundedLength = _length;
      if (roundedLength % 0.0625 != 0) {
        if (roundedLength % 0.0625 >= 0.03125) {
          roundedLength = roundedLength + (roundedLength % 0.0625);
        } else {
          roundedLength = roundedLength - (roundedLength % 0.0625);
        }
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Image Editor'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Results:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 48, color: Colors.blue),
            ),
            Text(
              "\n\n" +
              "Screw Length:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${(_length).toStringAsFixed(4)} inches",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "\n" +
              "Rounded Length (nearest 16th inch):",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${(roundedLength)} inches",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "\n" +
              "Screw Thread Pitch:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${(_pitch).toStringAsFixed(4)} inches",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "\n\n" +
              "Using this information, you can further identify and purchase screws at:\n",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24),
            ),
            InkWell(
              child: Text(
                "https://www.mcmaster.com/screws",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () => launch('https://www.mcmaster.com/screws'),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Image Editor'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // Select an image from the camera or gallery
        floatingActionButton: Row(
          children: <Widget>[
            if (_imageFile == null) ...[
              Spacer(
                flex: 5,
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => _pickImage(ImageSource.camera),
                child: Icon(Icons.photo_camera),
              ),
              Spacer(
                flex: 1,
              ),
              FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Icon(Icons.photo_library),
              ),
              Spacer(
                flex: 5,
              ),
            ]
          ],
        ),

        // Preview the image and crop it
        body: Column(
          children: <Widget>[
            if (_imageFile != null) ...[

              Image.file(_imageFile),

              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
              Spacer(flex: 1,),
              Uploader(file: _imageFile, token: _token),
              Spacer(flex: 1,)
            ]
          ],
        ),
      );
    }
  }
}

class Uploader extends StatefulWidget {

  final File file;
  final String token;

  Uploader({Key key, this.file, this.token}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  // FirebaseApp.initializeApp(Context);

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://screw-user-images');

  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() {

    /// Unique file name for the file
    //print("3: " + widget.token);
    String filePath = '${widget.token}/${DateTime.now()}.png';
    //String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {

      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(

                children: [
                  if (_uploadTask.isComplete)
                    Text('Uploaded! Please wait for results.'),


                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume,
                    ),

                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause),
                      onPressed: _uploadTask.pause,
                    ),

                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % '
                  ),
                ],
              );
          });


    } else {

      // Allows user to decide when to start the upload
      return Row(children: <Widget>[
        Spacer(flex: 1,),
        FloatingActionButton.extended(
          label: Text('Upload image for processing'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        ),
        Spacer(flex: 1,),
      ],);
    }
  }
}
