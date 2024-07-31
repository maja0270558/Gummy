//
//  File.swift
//
//
//  Created by DjangoLin on 2024/7/31.
//

import Dependencies
import Foundation
import MusicKit

public struct GummyPlaybackService: Sendable {
    public var requestPermition: @Sendable () async -> MusicAuthorization.Status
    public var isPlaying: @Sendable () -> Bool
    public var haveSubscribtion: @Sendable () -> Bool
}

public extension DependencyValues {
    var playbackClient: GummyPlaybackService {
        get { self[GummyPlaybackService.self] }
        set { self[GummyPlaybackService.self] = newValue }
    }
}

extension GummyPlaybackService: DependencyKey {
    public static let liveValue: GummyPlaybackService = .init {
        await MusicAuthorization.request()
    } isPlaying: {
        false
    } haveSubscribtion: {
        false
    }
}

extension GummyPlaybackService: TestDependencyKey {
    public static let testValue: GummyPlaybackService = unimplemented("")
}
