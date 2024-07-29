//
//  GummyApp.swift
//  Gummy
//
//  Created by DjangoLin on 2024/7/29.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State: Equatable {}
    enum Action: Equatable {}

    var body: some Reducer<State, Action> {
        Reduce(core)
    }

    func core(into state: inout State, action: Action) -> Effect<Action> {}
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        EmptyView()
    }
}

@main
struct GummyAppView: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
        }
    }
}
