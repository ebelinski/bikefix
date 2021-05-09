import SwiftUI
import CoreLocation

struct Home: View {

  @ObservedObject var nodeProvider: NodeProvider

  var body: some View {
    MapScreen(nodeProvider: nodeProvider)
      .accentColor(Color.bikefixPrimary)
  }

}

#if DEBUG
struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home(nodeProvider: NodeProvider())
  }
}
#endif
