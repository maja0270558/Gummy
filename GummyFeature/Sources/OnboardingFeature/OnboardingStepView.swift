//
//  SwiftUIView.swift
//
//
//  Created by DjangoLin on 2024/8/19.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingStepView: View {
    let store: StoreOf<OnboardingReducer>

    var body: some View {
        switch store.step {
        case .step1_Welcome:
            Text("Welcome")
        case .step2_Auth:
            VStack {
                
                Text("Let get things done one by one\nTo use Gummy we need your permition with Apple Music")
                
                Button("Auth") {
                    store.send(.userClickAuth)
                }
            }
        case .step3_Allow:
            Text("Now we moving on")
        default:
            Text("")
        }
    }
}

#Preview {
    OnboardingStepView(
        store: Store(
            initialState: OnboardingReducer.State(),
            reducer: {  OnboardingReducer() }
        )
    )
}
