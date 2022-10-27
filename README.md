# myflutterapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


use adb reverse to expose port 5551 on device to 8080 on computer  

nodejs server is listening on 8080    

adb reverse tcp:5551 tcp:8080   

adb reverse has bug prior to android P that it doesn't work on tcp but works on usb   

for example, if tcp connection has been setup  
adb tcpip 5555  
adb connect <ip of phone, about device->status>   
adb devices  

disconnect the usb   

adb.exe: error: more than one device/emulator   
is thrown even though there is only one device   


http package does not have option for self signed certificate and is higher level api than
dart:io's httpclient. Httpclient has option to specify SecurityContext and  badCertificateCallback.  

Copy the public certificates to the asset folder and update pubspec.yaml in order to use in SecurityContext.


