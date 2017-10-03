//
//  AppDelegate.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/17/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
import OneSignal
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      OneSignal.initWithLaunchOptions( launchOptions, appId: "de97fefb-682f-4f5a-acdf-83b8efe4d1f9" )
      OneSignal.inFocusDisplayType = OSNotificationDisplayType.none
      registerForPushNotifications( application )
      
      UIApplication.shared.statusBarStyle = .lightContent
      
      return true
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
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }

   func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
      var token = ""
      for i in 0..<deviceToken.count {
         token = token + String( format: "%02.2hhx", arguments: [deviceToken[i]] )
      }
   }
   
   // Notification: Device Registration
   func registerForPushNotifications( _ application: UIApplication ) {
      // Notification Actions
      let joinCompetitionAction = UNNotificationAction( identifier: "JOIN_COMPETE", title: "Join Competition", options: [] )
      // joinCompetitionAction.activationMode = .foreground
      
      let pendingAction = UNNotificationAction( identifier: "PEND_TASK", title: "Not Now", options: [] )
      // pendingAction.activationMode = .background
      
      let packerActions = [ joinCompetitionAction, pendingAction ]
      let packerCategory = UNNotificationCategory(
         identifier: "PACKER_ACTIONS",
         actions: packerActions,
         intentIdentifiers: [], options: [] )
      
      if #available( iOS 10.0, * ) {
         let center = UNUserNotificationCenter.current()
         center.delegate = self
         center.setNotificationCategories( [packerCategory] )
         center.requestAuthorization( options: [.sound, .alert, .badge] ) { (granted, error) in
            if error == nil{
               UIApplication.shared.registerForRemoteNotifications()
            }
            else {
               
            }
         }
      }
   }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
   
   @available( iOS 10.0, * )
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      // print("User Info = ",notification.request.content.userInfo)
      
      if UIApplication.shared.applicationState == .active {
         let realm = try! Realm()
         let count = realm.objects( CounterRealm.self )
         
         try! realm.write {
            let new = (count.first?.counter)! + 1
            realm.create( CounterRealm.self, value: ["id": (count.first?.id)!, "counter": new], update: true )
         }
         NotificationCenter.default.post( name: NSNotification.Name( "count" ), object: self, userInfo: nil )
      }

      completionHandler([.alert, .badge, .sound])
   }
   
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      if UIApplication.shared.applicationState == .inactive || UIApplication.shared.applicationState == .background {
         let realm = try! Realm()
         let count = realm.objects( CounterRealm.self )
         
         try! realm.write {
            let new = (count.first?.counter)! + 1
            realm.create( CounterRealm.self, value: ["id": (count.first?.id)!, "counter": new], update: true )
         }
         NotificationCenter.default.post( name: NSNotification.Name( "count" ), object: self, userInfo: nil )
      }
      //switch response.actionIdentifier {
      //case "JOIN_COMPETE": break
      //default:
      //   break
      //}
   }
}
