import SwiftUI
import CoreLocation

struct ContentView: View {

  @State var nodeViewModels: [NodeViewModel] = []

  var body: some View {
    MapView(nodeViewModels: $nodeViewModels)
      .edgesIgnoringSafeArea(.vertical)
  }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
