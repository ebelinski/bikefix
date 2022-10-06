import SwiftUI
import CoreLocation

struct Home: View {

  @ObservedObject var nodeProvider: NodeProvider

  var body: some View {
    MapView(viewModel: MapViewModel(nodeProvider: nodeProvider))
      .accentColor(Color.bikefixPrimary)
  }

}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home(nodeProvider: NodeProvider())
  }
}
