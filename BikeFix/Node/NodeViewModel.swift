import Foundation
import MapKit

struct NodeViewModel {

  let id: Int
  let name: String
  let location: CLLocationCoordinate2D

  init(node: Node) {
    id = node.id
    name = node.tags.name ?? node.tags.description ?? node.tags.brand ?? "Unnamed"
    location = CLLocationCoordinate2D(latitude: node.lat, longitude: node.lon)
  }

}

extension NodeViewModel: Equatable {

  static func ==(lhs: NodeViewModel, rhs: NodeViewModel) -> Bool {
    lhs.id == rhs.id
  }

}
