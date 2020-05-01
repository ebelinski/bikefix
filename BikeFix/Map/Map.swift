import SwiftUI
import MapKit

struct Map: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider

  // MARK: - State

  @State var displayingLocationAuthRequest = false
  @State var shouldNavigateToUserLocation = false

  // MARK: - Instance variables

  let locationManager = CLLocationManager()

  let mapButtonDimension: CGFloat = 50

  // MARK: - Body view

  var body: some View {
    ZStack {
      map
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.horizontal)

      mapOverlays
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        // Setting it right away doesn't work, due to some funny behavior with MapView's mapViewDidChangeVisibleRegion method.
        self.shouldNavigateToUserLocation = true
      }
    }
  }

  // MARK: - Other views

  var map: some View {
    MapView(nodes: $nodeProvider.nodes,
            displayingLocationAuthRequest: $displayingLocationAuthRequest,
            shouldNavigateToUserLocation: $shouldNavigateToUserLocation)
  }

  var mapOverlays: some View {
    VStack {
      if nodeProvider.loading {
        HStack {
          Spacer()
          loadingIndicator
        }
      }

      Spacer()

      HStack {
        Spacer()
        locationButton
      }
    }
  }

  var loadingIndicator: some View {
    ActivityIndicator(isAnimating: .constant(true), style: .medium)
      .accessibility(label: Text("Loading data..."))
      .frame(minWidth: mapButtonDimension, minHeight: mapButtonDimension)
      .background(Color.mapButtonBackground)
      .cornerRadius(10)
      .shadow(color: Color.shadow, radius: 5)
      .padding()
  }

  var locationButton: some View {
    Button(action: {
      self.checkForLocationAuthorizationAndNavigateToUserLocation()
    }) {
      Image(systemName: "location")
        .imageScale(.large)
        .accessibility(label: Text("Locate Me"))
        .frame(minWidth: mapButtonDimension, minHeight: mapButtonDimension)
        .background(Color.mapButtonBackground)
        .cornerRadius(10)
        .shadow(color: Color.shadow, radius: 5)
    }
    .padding()
  }

  // MARK: - Methods

  func checkForLocationAuthorizationAndNavigateToUserLocation() {
    displayingLocationAuthRequest = false

    if CLLocationManager.authorizationStatus() == .notDetermined {
      print("location authorization not determined")
      displayingLocationAuthRequest = true
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
