import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Google Maps API 키: Flutter main()이 assets/env 값을 전달
    let mapsKeyChannel = FlutterMethodChannel(
      name: "quick_dine/maps_key",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    mapsKeyChannel.setMethodCallHandler { call, result in
      if call.method == "setApiKey", let key = call.arguments as? String {
        GMSServices.provideAPIKey(key)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
