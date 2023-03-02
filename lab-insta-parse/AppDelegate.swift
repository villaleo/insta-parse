//
//  AppDelegate.swift
//  lab-insta-parse
//
//  Created by Charlie Hieger on 10/29/22.
//  Revised by Leonardo Villalobos on 3/2/23.

import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.initializeParse()
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: Private helpers
    private func initializeParse() {        
        ParseSwift.initialize(
            applicationId: SecretManager.shared.getValue(for: .applicationId),
            clientKey: SecretManager.shared.getValue(for: .clientKey),
            serverURL: URL(string: "https://parseapi.back4app.com")!
        )
    }
}
