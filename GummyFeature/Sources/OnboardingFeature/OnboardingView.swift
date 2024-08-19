//
//  OnboardingView.swift
//
//
//  Created by DjangoLin on 2024/8/19.
//
import ComposableArchitecture
import SwiftUI
import PlaybackService

@Reducer
public struct OnboardingReducer {
    @Dependency(\.playerClient) var player

    public init() { }
    
    public enum OnboardingStep: Int, CaseIterable, Equatable {
        case step1_Welcome
        case step2_Auth
        case step3_Connect

        mutating func next() {
            self = Self(rawValue: self.rawValue + 1) ?? Self.allCases.last!
        }

        mutating func previous() {
            self = Self(rawValue: self.rawValue - 1) ?? Self.allCases.first!
        }
    }

    @ObservableState
    public struct State: Equatable {
        public var step: OnboardingStep
        public init(step: OnboardingStep) {
            self.step = step
        }
    }

    public enum Action: Equatable {
        case userClickNextStepButton
        case userClickPreStepButton
        case userChooseAuth(Bool)
    }

    public var body: some Reducer<State, Action> {
        Reduce(self.core)
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .userClickNextStepButton:
            if state.step == .step2_Auth {
                return .run { send in
                   let status = await player.prepare()
                    let success = status != .authorized
                    await send(.userChooseAuth(success))
                }
            }
            state.step.next()
            return .none
            
        case .userClickPreStepButton:
            state.step.previous()
            return .none
        case .userChooseAuth(_):
            
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
                    self.store.send(.userClickPreStepButton)
                }, label: {
                    Text("Skip")
                })
            }
            .padding(.horizontal)
            OnboardingStepView(store: self.store)
            HStack {
                Button(action: {
                    self.store.send(.userClickPreStepButton)
                }, label: {
                    Text("Pre")
                })

                Button(action: {
                    self.store.send(.userClickNextStepButton)
                }, label: {
                    Text("Next")
                })
            }
        }
    }
}

#Preview {
    OnboardingView(store:
        Store(
            initialState: OnboardingReducer.State(step: .step1_Welcome),
            reducer: { OnboardingReducer() },
            withDependencies: {
                $0.playerClient = .testValue
            }
        )
    )
}
