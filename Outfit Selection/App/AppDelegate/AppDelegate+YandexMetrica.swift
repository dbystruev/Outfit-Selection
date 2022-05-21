//
//  AppDelegate+YandexMetrica.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import YandexMobileMetrica

extension AppDelegate {
    private static var yandexAppMetricaKey = "..."
    private(set) static var yandexMetricaActivated = false
    
    /// Setup Yandex Metrica
    /// Called from AppDelegate.application(_:didFinishLaunchingWithOptions:)
    /// https://appmetrica.yandex.ru/docs/mobile-sdk-dg/ios/ios-quickstart.html
    public static func setupYandexMetrica() {
        // Initializing the AppMetrica SDK.
        if AppDelegate.yandexMetricaActivated { return }
        if !yandexAppMetricaKey.hasDigits {

            guard let yandexAppMetricaKey = Global.apiKeys[.yandexAppMetricaKey] else {
                debug("WARNING: \(APIKey.yandexAppMetricaKey) is not found")
                yandexMetricaActivated = true
                return
            }
            AppDelegate.yandexAppMetricaKey = yandexAppMetricaKey
        }
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: AppDelegate.yandexAppMetricaKey) else {
            debug("WARNING: YandexMobileMetrica configuration has not been initialized")
            return
        }
        YMMYandexMetrica.activate(with: configuration)
        AppDelegate.yandexMetricaActivated = true
    }
}
