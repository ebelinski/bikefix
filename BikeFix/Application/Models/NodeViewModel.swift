import Foundation
import MapKit

struct NodeViewModel: Identifiable {

  enum Kind {
    case bicycleRepairStation
    case bicycleShop
  }

  let id: Int
  let name: String
  let location: CLLocationCoordinate2D
  let kind: Kind

  init(node: Node) {
    id = node.id
    name = node.tags.name ?? node.tags.description ?? node.tags.brand ?? "Unnamed"
    location = CLLocationCoordinate2D(latitude: node.lat, longitude: node.lon)

    if node.tags.shop == "bicycle" {
      kind = .bicycleShop
    } else if (node.tags.amenity ?? "").contains("bicycle_repair_station") {
      kind = .bicycleRepairStation
    } else {
      kind = .bicycleRepairStation
    }
  }

}

extension NodeViewModel: Equatable {

  static func ==(lhs: NodeViewModel, rhs: NodeViewModel) -> Bool {
    lhs.id == rhs.id
  }

}
