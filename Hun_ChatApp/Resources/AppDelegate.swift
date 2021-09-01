//
//  AppDelegate.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

//  Swift
//
// AppDelegate.swift
import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //Google Sing In
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                
            } else {
                
            }
        }
        
        
        //firebase
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
       
        
        
        
        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var hendlrd: Bool
        //Google Sing In
        hendlrd = GIDSignIn.sharedInstance.handle(url)
        if hendlrd {
            return true
        }

        
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }

}
    

    
