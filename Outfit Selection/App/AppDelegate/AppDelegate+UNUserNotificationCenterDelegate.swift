//
//  AppDelegate+UNUserNotificationCenterDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//
import NotificationCenter

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Configure current user notification center
    func userNotificationCenter(configureFor application: UIApplication) {
        // Set self as delegate of current user notification center
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization for remote notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
        
        // Register to receive remote notifications
        application.registerForRemoteNotifications()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    /// Handles a notification that arrived while the app was running in the foreground
    /// - Parameters:
    ///   - center: the shared user notification center object that received the notification
    ///   - notification: the notification that is about to be delivered
    ///   - completionHandler: the block to execute with the presentation option for the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        appsFlyer(handlePushNotificationWith: notification.request.content.userInfo)
    }
}
