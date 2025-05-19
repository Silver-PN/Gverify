import Flutter
import UIKit
import xverifysdk
import UserNotifications

var flutterMethodChannel: FlutterMethodChannel?

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
    
        GeneratedPluginRegistrant.register(with: self)
        setupFlutterMethodChannel()
        registerViews()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
   
    
    private func setupFlutterMethodChannel() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        MethodChannel.shared.methodChannel = FlutterMethodChannel(name: "APP_CHANNEL",
                                                                  binaryMessenger: controller.binaryMessenger)
        MethodChannel.shared.handleEvent()
    }
    
    private func registerViews() {
        let cameraMrzFactory = CameraMrzFactory()
        registrar(forPlugin: "CameraMrzFactory")!.register(cameraMrzFactory, withId: "<camera_mrz_view>")
        let cameraLivenessFactory = CameraLivenessFactory()
        registrar(forPlugin: "CameraLivenessFactory")!.register(cameraLivenessFactory, withId: "<camera_liveness_view>")
        let cameraQRCodeFactory = CameraQRCodeFactory()
        registrar(forPlugin: "cameraQRCodeFactory")!.register(cameraQRCodeFactory, withId: "<camera_qr_view>")
    }
}

extension AppDelegate {
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
