//
//  SwiftUIView.swift
//
//
//  Created by DjangoLin on 2024/8/19.
//

import ComposableArchitecture
import SwiftUI
import MusicKit

struct OnboardingStepView: View {
    let store: StoreOf<OnboardingReducer>

    var body: some View {
        VStack {
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
                Text("Now we moving on checking your Apple music subscription.").onAppear(perform: {
                    store.send(.checkSubsciption)
                })
            case .step4_Subscription:
                if store.subscriptionState?.canPlayCatalogContent ?? false {
                    Text("Congrat good to go")

                } else {
                    if store.subscriptionState?.canBecomeSubscriber ?? false {
                        
                    }
                }
               
            }
            
            HStack {
                if store.step.canGoPreviousOne {
                    Button(action: {
                        self.store.send(.userClickPreStepButton)
                    }, label: {
                        Text("Pre")
                    })
                }
                
                if store.step.canGoNextOne {
                    Button(action: {
                        self.store.send(.userClickNextStepButton)
                    }, label: {
                        Text("Next")
                    })
                }
            }
        }
    }
}

#Preview {
    OnboardingStepView(
        store: Store(
            initialState: OnboardingReducer.State(),
            reducer: { OnboardingReducer() }
        )
    )
}
