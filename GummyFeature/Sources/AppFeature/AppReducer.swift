//
//  GummyApp.swift
//  Gummy
//
//  Created by DjangoLin on 2024/7/29.
//
import ComposableArchitecture
import OnboardingFeature
import PlaybackService
import SwiftUI

@Reducer
public struct AppReducer: Reducer {
    @Dependency(\.playerClient) var player

    @Reducer(state: .equatable, action: .equatable)
    public enum Destination {
        case onboarding(OnboardingReducer)
        case main
    }

    public init() {}

    @ObservableState
    public struct State: Equatable {
        @Presents var destination: Destination.State?

        public init() {}
    }

    public enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case appDelegate(AppDelegateReducer.Action)
        case didChangeScenePhase(ScenePhase)
    }

    public var body: some ReducerOf<Self> {
        Reduce(core)
            .ifLet(\.$destination, action: \.destination) {
                Destination.body
            }
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didChangeScenePhase:
            state.destination = .onboarding(OnboardingReducer.State(step: .step1_Welcome))
            return .none
        case .appDelegate:
            return .none
        case .destination:
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
        switch store.destination {
        case .main:
            EmptyView()
        case .onboarding:
            if let store = store.scope(
                state: \.destination?.onboarding, action: \.destination.onboarding
            ) {
                OnboardingView(store: store)
            }
        case .none:
            EmptyView()
        }
    }
}
