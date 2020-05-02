import SwiftUI
import MapKit

struct Map: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider
  @EnvironmentObject var userSettings: UserSettings

  // MARK: - State

  @State var showingSettings = false
  @State var displayingLocationAuthRequest = false
  @State var shouldNavigateToUserLocation = false

  // MARK: - Instance variables

  let locationManager = CLLocationManager()

  let mapButtonDimension: CGFloat = 50

  // MARK: - Body view

  var body: some View {
    ZStack {
      map

      mapOverlays
    }
    .sheet(isPresented: $showingSettings) {
      SettingsMain()
        .environmentObject(self.userSettings)
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
    MapViewRepresentable(nodes: $nodeProvider.nodes,
                         displayingLocationAuthRequest: $displayingLocationAuthRequest,
                         shouldNavigateToUserLocation: $shouldNavigateToUserLocation)
      .accentColor(Color.bikefixPrimaryOnWhite)
      .edgesIgnoringSafeArea(.all)
  }

  var mapOverlays: some View {
    HStack {
      Spacer()

      VStack {
        Spacer()
        if nodeProvider.loading {
          loadingIndicator
        }
        settingsButton
        locationButton
      }
      .padding(10)
    }
  }

  var loadingIndicator: some View {
    ActivityIndicator(isAnimating: .constant(true), style: .medium)
      .accessibility(label: Text("Loading data..."))
      .frame(minWidth: mapButtonDimension, minHeight: mapButtonDimension)
      .background(Color.mapButtonBackground)
      .cornerRadius(8)
      .shadow(color: Color.shadow, radius: 5)
      .padding(5)
  }

  var settingsButton: some View {
    Button(action: { self.showingSettings.toggle() }) {
      Image(systemName: "gear")
        .mapButtonImageStyle()
        .accessibility(label: Text("Settings"))
    }
    .padding(5)
    .hoverEffect()
  }

  var locationButton: some View {
    Button(action: {
      self.checkForLocationAuthorizationAndNavigateToUserLocation()
    }) {
      Image(systemName: "location")
        .mapButtonImageStyle()
        .accessibility(label: Text("Locate Me"))
    }
    .padding(5)
    .hoverEffect()
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
