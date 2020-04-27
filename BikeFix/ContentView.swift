import SwiftUI
import CoreLocation

struct ContentView: View {

  var body: some View {
    TabView {
      Map()
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.horizontal)
        .tabItem {
          Image(systemName: "map.fill")
          Text("Map")
        }
      Settings()
        .tabItem {
          Image(systemName: "gear")
          Text("Settings")
        }
    }
  }

}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
