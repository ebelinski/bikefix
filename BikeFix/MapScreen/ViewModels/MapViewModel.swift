import Foundation
import MapKit

class MapViewModel: NSObject, ObservableObject {

  @Published var showingSettings = false
  @Published var displayingLocationAuthRequest = false
  @Published var shouldNavigateToUserLocation = false
  @Published var openedNodeVM: NodeViewModel? = nil

  var nodeProvider: NodeProvider

  private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    return locationManager
  }()

  init(nodeProvider: NodeProvider) {
    self.nodeProvider = nodeProvider
  }

  // MARK: - Public methods

  func checkForLocationAuthorizationAndNavigateToUserLocation() {
    displayingLocationAuthRequest = false

    if locationManager.authorizationStatus == .notDetermined {
      log.info("location authorization not determined")
      displayingLocationAuthRequest = true
      locationManager.requestWhenInUseAuthorization()
      return
    }

    shouldNavigateToUserLocation = true
  }

  func onNodeDetailDismiss() {
    ReviewHelper.shared.allTimeNodeDetailDismissCount += 1
    ReviewHelper.shared.requestReviewIfAppropriate()
  }

}

extension MapViewModel: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      displayingLocationAuthRequest = false
    default:
      break
    }
  }
}
