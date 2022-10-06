import Foundation
import MapKit

class MapViewModel: ObservableObject {
  
  @Published var showingSettings = false
  @Published var displayingLocationAuthRequest = false
  @Published var shouldNavigateToUserLocation = false
  @Published var openedNodeVM: NodeViewModel? = nil
  
  var nodeProvider: NodeProvider
  
  let locationManager = CLLocationManager()
  
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
