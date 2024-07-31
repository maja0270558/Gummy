//
//  App.swift
//  Gummy
//
//  Created by DjangoLin on 2024/7/31.
//
import AppFeature
import ComposableArchitecture
import Foundation
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store: StoreOf<AppReducer> = .init(initialState: AppReducer.State()) {
        AppReducer()
    }
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        store.send(.appDelegate(.didFinishLaunching))
        return true
    }
}

@main
struct GummyiOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AppView(store: appDelegate.store)
        }
        .onChange(of: scenePhase) { _, _ in
            appDelegate.store.send(.didChangeScenePhase(scenePhase))
        }
    }
}
