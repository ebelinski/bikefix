import MapKit

final class NodeAnnotation: NSObject, MKAnnotation {
  let id: Int
  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(nodeViewModel: NodeViewModel) {
    self.id = nodeViewModel.id
    self.title = nodeViewModel.name
    self.coordinate = nodeViewModel.location
  }
}
