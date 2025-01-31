//
//  File.swift
//
//
//  Created by DjangoLin on 2024/7/31.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct AppDelegateReducer {
    public struct State: Equatable {
        public init() {}
    }
    public enum Action: Equatable {
        case didFinishLaunching
        case didChangeScenePhase(ScenePhase)
    }

    public var body: some Reducer<State, Action> {
        Reduce(core)
    }

    public func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didFinishLaunching:
            return .none
        case .didChangeScenePhase:
            return .none
        }
    }
}
