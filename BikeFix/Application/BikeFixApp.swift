import SwiftUI

@main
struct BikeFixApp: App {

  @StateObject var nodeProvider = NodeProvider()

  @SceneBuilder var body: some Scene {
    WindowGroup {
      Home(nodeProvider: nodeProvider)
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
