import SwiftUI

@main
struct BikeFixApp: App {

  @StateObject var nodeProvider = NodeProvider()
  @StateObject var userSettings = UserSettings()

  @Environment(\.scenePhase) private var scenePhase

  private var didAppearOnce = false

  @SceneBuilder var body: some Scene {
    WindowGroup {
      Home(nodeProvider: nodeProvider, userSettings: userSettings)
    }
  }

  init() {
    Products.store.requestProducts { success, tipProducts in
      if success, let tipProducts = tipProducts {
        Products.tipProducts = tipProducts
      }
    }

    ReviewHelper.shared.allTimeAppOpenCount += 1
  }

}
