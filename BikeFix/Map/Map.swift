import SwiftUI
import MapKit

struct Map: View {

  @EnvironmentObject var nodeProvider: NodeProvider

  @State var currentlyDisplayingLocationAuthorizationRequest = false
  @State var shouldNavigateToUserLocation = false

  let locationManager = CLLocationManager()

  var body: some View {
    ZStack {
      MapView(nodes: $nodeProvider.nodes,
              currentlyDisplayingLocationAuthorizationRequest: $currentlyDisplayingLocationAuthorizationRequest,
              shouldNavigateToUserLocation: $shouldNavigateToUserLocation)

      HStack {
        Spacer()
        VStack {
          Spacer()
          Button(action: {
            self.checkForLocationAuthorizationAndNavigateToUserLocation()
          }) {
            Image(systemName: "location")
              .imageScale(.large)
              .accessibility(label: Text("Locate Me"))
              .padding()
          }
        }
      }
    }
    .onAppear {
      self.shouldNavigateToUserLocation = true
    }
  }

  func checkForLocationAuthorizationAndNavigateToUserLocation() {
    currentlyDisplayingLocationAuthorizationRequest = false

    if CLLocationManager.authorizationStatus() == .notDetermined {
      print("location authorization not determined")
      currentlyDisplayingLocationAuthorizationRequest = true
      locationManager.requestWhenInUseAuthorization()
      return
    }

    shouldNavigateToUserLocation = true
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    Map()
  }
}
#endif
