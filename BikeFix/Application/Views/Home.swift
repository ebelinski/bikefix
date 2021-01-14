import SwiftUI
import CoreLocation

struct Home: View {

  var body: some View {
    MapScreen()
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
