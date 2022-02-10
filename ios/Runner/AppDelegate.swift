import UIKit
import Flutter
import AuthenticationServices

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var appleSignResult: FlutterResult?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channelApple = FlutterMethodChannel(name: "com.laodev.labyrinth/apple_sign",  binaryMessenger: controller.binaryMessenger)
        channelApple.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "init") {
                self.appleSignResult = result
                self.handleAppleIdRequest()
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            appleSignResult!(appleIDCredential.identityToken)
        } else {
            appleSignResult!("Not found any auth")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}
