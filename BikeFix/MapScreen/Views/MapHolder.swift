import SwiftUI
import MapKit

struct MapHolder: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider
  @EnvironmentObject var userSettings: UserSettings

  // MARK: - Bindings

  @Binding var nodes: [Node]
  @Binding var openedNodeVM: NodeViewModel?
  @Binding var displayingLocationAuthRequest: Bool
  @Binding var shouldNavigateToUserLocation: Bool

  // MARK: - State

  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
  )

  // MARK: - Instance variables

  let locationManager = CLLocationManager()
  var previouslySearchedRegion: MKCoordinateRegion?

  // MARK: - Body view

  var body: some View {
    Map(coordinateRegion: $region)
  }

  // MARK: - Methods

  

}
