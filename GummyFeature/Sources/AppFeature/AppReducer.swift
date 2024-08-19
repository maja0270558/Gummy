//
//  GummyApp.swift
//  Gummy
//
//  Created by DjangoLin on 2024/7/29.
//
import ComposableArchitecture
import SwiftUI
import PlaybackService

@Reducer
public struct AppReducer: Reducer {
    @Dependency(\.playerClient) var player
    
    public enum Destination {
        case onboarding
        case main
    }
    
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
        case appDelegate(AppDelegateReducer.Action)
        case didChangeScenePhase(ScenePhase)
    }

    public var body: some ReducerOf<Self> {
        Reduce(core)
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didChangeScenePhase:
            return .none
        case .appDelegate:
            return .none
        }
    }
}

public struct AppView: View {
    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        EmptyView()
    }
}
