import XCTest
import ComposableArchitecture
@testable import AppFeature

class AppFeatureTests: XCTestCase {
    
    @MainActor
    func testAppLaunch() async {
        let store = TestStore(
            initialState: AppReducer.State(),
            reducer: { AppReducer() }
        )
        
        await store.send(.appDelegate(.didFinishLaunching))
    }
}
