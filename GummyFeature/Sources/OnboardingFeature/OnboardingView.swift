//
//  OnboardingView.swift
//
//
//  Created by DjangoLin on 2024/8/19.
//
import ComposableArchitecture
import PlaybackService
import SwiftUI

@Reducer
public struct OnboardingReducer {
    @Dependency(\.playerClient) var player
    public init() {}

    // - MARK: State
    @ObservableState
    public struct State: Equatable {
        public enum OnboardingStep: Int, CaseIterable, Equatable {
            case step1_Welcome
            case step2_Auth
            case step3_Allow
            case step4_Subscription

            mutating func next() {
                self = Self(rawValue: self.rawValue + 1) ?? Self.allCases.last!
            }

            mutating func previous() {
                self = Self(rawValue: self.rawValue - 1) ?? Self.allCases.first!
            }

            var canGoPreviousOne: Bool {
                switch self {
                case .step1_Welcome: false
                case .step2_Auth: true
                case .step3_Allow: false
                case .step4_Subscription: false
                }
            }
            
            var canGoNextOne: Bool {
                switch self {
                case .step1_Welcome: true
                case .step2_Auth: false
                case .step3_Allow: true
                case .step4_Subscription: false
                }
            }
        }

        public var step: OnboardingStep
        public var subscriptionState: MusicPlayerClient.Subscription?
        
        public init(step: OnboardingStep = .step1_Welcome) {
            self.step = step
        }
    }

    // - MARK: Action
    public enum Action: Equatable {
        case userClickNextStepButton
        case userClickPreStepButton
        case userClickSkipButton
        case userClickAuth
        case receivedPlayerStatus(MusicPlayerClient.MusicPlayerAuthState)
        case checkSubsciption
        case receivedSubsciption(MusicPlayerClient.Subscription?)
    }

    // - MARK: Reducer
    public var body: some Reducer<State, Action> {
        Reduce(self.core)
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .userClickNextStepButton:
            state.step.next()
            return .none
        case .userClickPreStepButton:
            state.step.previous()
            return .none
        case .userClickAuth:
            return .run { send in
                let status = await player.authState()
                await send(.receivedPlayerStatus(status))
            }
        case .userClickSkipButton:
            return .none
        case let .receivedPlayerStatus(status):
            if status == .authorized {
                state.step = .step3_Allow
            }
            return .none
        case .checkSubsciption:
            return .run { send in
                let sub = try? await player.subscriptionState()
                await send(.receivedSubsciption(sub))
            }
        case let .receivedSubsciption(sub):
            state.subscriptionState = sub
            state.step = .step4_Subscription
            return .none
        }
        
        
    }
}

public struct OnboardingView: View {
    let store: StoreOf<OnboardingReducer>

    public init(store: StoreOf<OnboardingReducer>) {
        self.store = store
    }

    public var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.store.send(.userClickSkipButton)
                }, label: {
                    Text("Skip")
                })
            }
            .padding(.horizontal)
            OnboardingStepView(store: self.store)
        }
    }
}

#Preview {
    OnboardingView(store:
        Store(
            initialState: OnboardingReducer.State(),
            reducer: { OnboardingReducer() },
            withDependencies: {
                $0.playerClient = .testValue
            }
        )
    )
}
