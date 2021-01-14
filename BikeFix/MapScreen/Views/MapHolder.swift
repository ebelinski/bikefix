import SwiftUI
import MapKit

struct MapHolder: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider
  @EnvironmentObject var userSettings: UserSettings

  // MARK: - Bindings

  @Binding var nodes: [Node]
  @Binding var openedNodeVM: NodeViewModel?

  // MARK: - State

  @State private var region = MKCoordinateRegion()

  // MARK: - Instance variables

  let locationManager = CLLocationManager()
  var previouslySearchedRegion: MKCoordinateRegion?

  // MARK: - Body view

  var body: some View {
    Map(
      coordinateRegion: $region,
      interactionModes: .all,
      showsUserLocation: true
    )
  }

  // MARK: - Methods

  

}
