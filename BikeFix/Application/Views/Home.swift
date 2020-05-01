import SwiftUI
import CoreLocation

struct Home: View {

  var body: some View {
    TabView {
      Map()
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
    .accentColor(Color.bikefixPrimary)
  }

}

#if DEBUG
struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
#endif
