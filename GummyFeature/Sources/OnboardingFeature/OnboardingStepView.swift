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
            Text("Let get things done one by one\nTo use Gummy we need your permition with Apple Music")
        default:
            Text("")
        }
    }
}

#Preview {
    OnboardingStepView(
        store: Store(
            initialState: OnboardingReducer.State(step: .step1_Welcome),
            reducer: {  OnboardingReducer() }
        )
    )
}
