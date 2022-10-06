import Foundation
import MapKit

class MapViewModel: ObservableObject {

  @Published var showingSettings = false
  @Published var displayingLocationAuthRequest = false
  @Published var openedNodeVM: NodeViewModel? = nil
  @Published var mapRegion = MKCoordinateRegion()

  var nodeProvider: NodeProvider

  let locationManager = CLLocationManager()

  init(nodeProvider: NodeProvider) {
    self.nodeProvider = nodeProvider
  }

  // MARK: - Public methods

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

  func onNodeDetailDismiss() {
    ReviewHelper.shared.allTimeNodeDetailDismissCount += 1
    ReviewHelper.shared.requestReviewIfAppropriate()
  }

}
