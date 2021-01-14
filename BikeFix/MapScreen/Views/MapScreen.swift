import SwiftUI
import MapKit

struct MapScreen: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider
  @EnvironmentObject var userSettings: UserSettings

  // MARK: - State

  @State var showingSettings = false
  @State var openedNodeVM: NodeViewModel? = nil
  @State var mapRegion = MKCoordinateRegion()

  // MARK: - Instance variables

  let locationManager = CLLocationManager()
  let mapButtonDimension: CGFloat = 50

  // MARK: - Body view

  var body: some View {
    ZStack {
      map
        .sheet(item: $openedNodeVM) { nodeVM in
          NodeDetails(nodeVM: nodeVM)
            .navigationViewStyle(StackNavigationViewStyle())
        }

      mapOverlays
    }
    .onAppear {
      moveToUserLocation()
    }
  }

  // MARK: - Other views

  var map: some View {
    Map(
      coordinateRegion: $mapRegion,
      interactionModes: .all,
      showsUserLocation: true
    )
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
        locateMeButton
      }
      .padding(10)
    }
    .padding(.bottom, 20)
  }

  var loadingIndicator: some View {
    ProgressView()
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
    .sheet(isPresented: $showingSettings) {
      SettingsMain()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(self.userSettings)
    }
  }

  var locateMeButton: some View {
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
    if locationManager.authorizationStatus == .notDetermined {
      log.info("location authorization not determined")
      locationManager.requestWhenInUseAuthorization()
      return
    }

    moveToUserLocation()
  }

  func moveToUserLocation() {
    guard let location = locationManager.location else { return }

    mapRegion = MKCoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.02,
                             longitudeDelta: 0.02)
    )
  }

}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    MapScreen()
  }
}
#endif
