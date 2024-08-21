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
    
    public struct Subscription : Equatable, Hashable, Sendable {
        public let canPlayCatalogContent: Bool
        public let canBecomeSubscriber: Bool
        public let hasCloudLibraryEnabled: Bool
    }

    
    public enum MusicPlayerAuthState: Equatable, Sendable {
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
    
    public var authState: @Sendable () async -> MusicPlayerAuthState
    public var subscriptionState: @Sendable () async throws -> Subscription
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
    static var apple: MusicPlayerClient = {
        .init(
            authState: {
                let authStatus = await MusicAuthorization.request()
                return .init(status: authStatus)
            },
            subscriptionState: {
                let subStatus = try await MusicSubscription.current
                let customSub = Subscription(canPlayCatalogContent: subStatus.canPlayCatalogContent,
                                             canBecomeSubscriber: subStatus.canBecomeSubscriber,
                                             hasCloudLibraryEnabled: subStatus.hasCloudLibraryEnabled)
                return customSub
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
    }()
}

let musicPlayer = SystemMusicPlayer.shared

public func testPlay() async {
    await searchMusicAndPlay()
}

func searchMusicAndPlay() async {
    var request = MusicCatalogSearchRequest(term: "Song", types: [Song.self])
    do {
        let response = try await request.response()
        if let song = response.songs.first {
            playSong(song)
        }
    } catch {
        print("搜尋失敗: \(error)")
    }
}

func playSong(_ song: Song) {
    Task {
        do {
            try await musicPlayer.queue.insert(song, position: .afterCurrentEntry)
            try await musicPlayer.play()
        } catch {
            print("播放失敗: \(error)")
        }
    }
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

