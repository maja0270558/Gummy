//
//  MusicPlayerClient.swift
//
//
//  Created by DjangoLin on 2024/7/31.
//

import Dependencies
import Foundation
import MusicKit
import Combine

public struct MusicPlayerClient: Sendable, Equatable {
    let id = UUID()
    
    public static func == (lhs: MusicPlayerClient, rhs: MusicPlayerClient) -> Bool {
        lhs.id == rhs.id
    }
    
    public enum State: Equatable {
        case stopped
        case playing
        case paused
        case interrupted
        case seekingForward
        case seekingBackward
    }
    
    public enum MusicPlayerAuthState: Equatable {
        case authorized
        case restricted
        case notDetermined
        case denied
        
        init(status: MusicAuthorization.Status) {
            switch status {
                case .authorized:
                self = .authorized
                case .restricted:
                self = .restricted
                case .notDetermined:
                self = .notDetermined
                case .denied:
                self = .denied
                @unknown default:
                self = .denied
            }
        }
    }
    
    public var prepare: @Sendable () async -> MusicPlayerAuthState
    public var state: @Sendable () async -> MusicPlayerClient.State
    public var isPreparedToPlay: @Sendable () async -> Bool
    public var play: @Sendable () async throws -> Void
    public var pause: @Sendable () async throws -> Void
    public var stop: @Sendable () async throws -> Void
    public var playbackTime: @Sendable () async throws -> TimeInterval
    public var beginSeekingForward: @Sendable () async throws -> Void
    public var beginSeekingBackward: @Sendable () async throws -> Void
    public var endSeeking: @Sendable () async throws -> Void
    public var skipToNextEntry: @Sendable () async throws -> Void
    public var restartCurrentEntry: @Sendable () async throws -> Void
    public var skipToPreviousEntry: @Sendable () async throws -> Void
}


public extension MusicPlayerClient {
    static let apple: MusicPlayerClient = .init(
        prepare: {
            let status = await MusicAuthorization.request()
            return .init(status: status)
        },
        state: { .playing },
        isPreparedToPlay: { false },
        play: { try await SystemMusicPlayer.shared.play() },
        pause: {  SystemMusicPlayer.shared.pause() },
        stop: { SystemMusicPlayer.shared.stop() },
        playbackTime: { 0 },
        beginSeekingForward: {},
        beginSeekingBackward: {},
        endSeeking: {},
        skipToNextEntry: {},
        restartCurrentEntry: {},
        skipToPreviousEntry: {}
    )
}



public extension DependencyValues {
    var playerClient: MusicPlayerClient {
        get { self[MusicPlayerClient.self] }
        set { self[MusicPlayerClient.self] = newValue }
    }
}

extension MusicPlayerClient: DependencyKey {
    public static var liveValue: MusicPlayerClient = .apple
}

