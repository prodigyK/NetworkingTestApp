//
//  AppDelegate.swift
//  NetworkingTestApp
//
//  Created by Konstantin Petkov on 20.09.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bgSessionCompletionHandler: (() -> ())?

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler
        print("=== handleEventsForBackgroundURLSession")
    }



}

