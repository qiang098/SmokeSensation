//
//  AppDelegate.swift
//  智慧烟感
//
//  Created by Mr.yang on 2018/11/22.
//  Copyright © 2018年 Mr.yang. All rights reserved.
//

import UIKit
import CoreLocation


#if DEBUG
var isProduction = false
#else
var isProduction = true
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if(notification.request.trigger is UNPushNotificationTrigger) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if(response.notification.request.trigger is UNPushNotificationTrigger) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if ((notification != nil) && notification!.request.trigger is UNPushNotificationTrigger) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult(rawValue: 0)!)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册 APNs 失败",error)
    }
    

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        Thread.sleep(forTimeInterval: 10)
        
        let _ = LocationManager.shareManager.creatLocationManager()
        
        //LeanCloud
        AVOSCloud.setApplicationId("TkvHn88V1EavDyOvSXw8clrX-gzGzoHsz", clientKey: "bhJfVomaM3ntoHCGSyl5rWTp")
        
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue)|Int(JPAuthorizationOptions.providesAppNotificationSettings.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)|Int(JPAuthorizationOptions.sound.rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "e67736b6f2f67ea97330b0dd", channel: "App Store", apsForProduction: isProduction, advertisingIdentifier: advertisingId)
        
        if "loginResult".get == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! UINavigationController
        }
        
        getIsUpdate()
        return true
    }
    
    func getIsUpdate() {
        let query = AVQuery(className: "AppVersion")
        query.findObjectsInBackground { (objects, error) in
            if objects != nil {
                let object = objects!.first as! AVObject
                if (object["isUpdate"] as! Bool) && (object["version"] as! String) != (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) {
                    let alertView = UIAlertController(title: "⚠️警告", message: "为了不影响您的使用，请前往AppStore更新", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "前往", style: .default, handler: { (action) in
                        UIApplication.shared.open(URL(string: object["url"] as! String)!, options: [:], completionHandler: nil)
                    })
                    alertView.addAction(ok)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        getIsUpdate()
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

