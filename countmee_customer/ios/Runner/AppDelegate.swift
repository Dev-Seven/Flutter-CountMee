import UIKit
import Flutter
import Firebase
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
   
    GMSServices.provideAPIKey("AIzaSyAchX9i5U4SB62u6j5yPaZG0qY2eQtJTHQ")
    return true
  }
}

// import UIKit
// import Firebase
// import GoogleMaps



// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {

//   var window: UIWindow?

//   func application(_ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions:
//       [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//     FirebaseApp.configure()
//     GMSServices.provideAPIKey("AIzaSyAchX9i5U4SB62u6j5yPaZG0qY2eQtJTHQ")

//     return true
//   }
// }
