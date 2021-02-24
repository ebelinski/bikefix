import SwiftUI
import CoreLocation

struct Home: View {

  @ObservedObject var nodeProvider: NodeProvider
  @ObservedObject var userSettings: UserSettings

  var body: some View {
    MapScreen(nodeProvider: nodeProvider, userSettings: userSettings)
      .accentColor(Color.bikefixPrimary)
  }

}

#if DEBUG
struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home(nodeProvider: NodeProvider(), userSettings: UserSettings())
  }
}
#endif
