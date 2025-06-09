import Flutter
import UIKit
import FirebaseCore
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
        // --- ADD THIS METHOD for Google Sign-In redirect ---
  @available(iOS 9.0, *)
  override func application(_ app: UIApplication, open url: URL,
   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
   var handled: Bool
   handled = GIDSignIn.sharedInstance.handle(url) // For Google Sign-In
   if handled {
         return true
   }
   // Handle other Flutter URL schemes if needed
   return super.application(app, open: url, options: options)
   }
}
