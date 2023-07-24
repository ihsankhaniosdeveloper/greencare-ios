//
//  AppDelegate.swift
//  Gardner
//
//  Created by Rashid Khan on 18/04/2023.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import StripeCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().tintColor = .black
        self.decideRootViewController()
        
        StripeAPI.defaultPublishableKey = Constatns.stripePublishableKey
        
        // Push Notification Registration
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func decideRootViewController() {
        if UserSession.instance.isValid {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
            
            window?.rootViewController = homeVC
            window?.makeKeyAndVisible()
            return
        }
        
        let navigationController = UINavigationController(rootViewController: LoginViewController.make(presenter: LoginPresenter(authService: UserService(apiClient: APIClient(session: .default)))))
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
  // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)

        return [[.alert, .sound, .badge]]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
}
