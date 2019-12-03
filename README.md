# Manufacture Instrument Recognition: SmartViz
This repo contains the SmartViz application, which is the front-end app for the Manufacture Instrument Recognition project. This is a Flutter application, intended to be cross-platform. With this app, you can take a picture of a screw on a template, and retrieve screw length and thread pitch!

## Release Notes (version 1.0)

### New Features
* Deleted Album Icon and page, refactored it into the Image Editor page
* Connected to the Google Cloud backend
	* Photo is uploaded to cloud storage
	* Firebase Cloud Messaging is used to catch notification containing results
* Added a new page for results on catch of notification
	
### Bug Fixes
* Fixed lack of proper firebase initialization
* Fixed buggy rendering of buttons on Image Editor
	
### Known Bugs
* If the firebase token doesn't initialize upon app start, in some cases, upload to firebase will stall
* History and Account Info features not yet fully functional

## Install/Testing Guide

### Prerequisites
* Download and install Flutter version: ```>=1.9.1+hotfix.5 <2.0.0``` at https://flutter.dev/docs/get-started/install
* You must have Dart version: ```>=2.2.2 <3.0.0``` installed before proceeding (should install with flutter)
* You must have an iOS or Android emulator to open the application, or an Android phone with USB Debugging
* **Recommended:** Install Android Studio or VSCode with the Flutter and Dart plugins for easy development.
	
### Dependencies
See the ```pubspec.yaml``` file. Since this is a Flutter project, when running the project, the dependencies will automatically be downloaded.
  
### Download
Simply clone this repo.
	
### Build
No need to implicitely build, but when rerunning, it may help to run the following in the root directory of the project:
```
flutter clean
```
	
### Run
* Open your prefered command line with ```flutter``` installed and make sure you are at root directory of the repo
* Launch your emulator.
* Run the command:
```
flutter run
```
* You should be able to see the application on your emulator or phone.
