import SwiftUI

@main
struct BikeFixApp: App {

  @StateObject var nodeProvider = NodeProvider()
  @StateObject var userSettings = UserSettings()

  @Environment(\.scenePhase) private var scenePhase

  @SceneBuilder var body: some Scene {
    WindowGroup {
        Home(nodeProvider: nodeProvider, userSettings: userSettings)
            .onAppear(perform: didAppear)
    }
  }

  private func didAppear() {
    Products.store.requestProducts { success, tipProducts in
      if success, let tipProducts = tipProducts {
        Products.tipProducts = tipProducts
      }
    }
  }

}
