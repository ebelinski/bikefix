import Foundation
import MapKit

struct NodeViewModel: Identifiable {

  enum Kind {
    case bicycleRepairStation
    case bicycleShop
  }

  let node: Node

  let id: Int
  let name: String
  let address: String?
  let location: CLLocationCoordinate2D
  let kind: Kind

  var lastUpdated: String {
    get {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      guard let lastChangedDate = formatter.date(from: node.timestamp) else { return "" }
      formatter.dateFormat = "MMM d, yyyy, h:mm a"
      return formatter.string(from: lastChangedDate)
    }
  }

  init(node: Node) {
    self.node = node

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

    var tempAddress = ""

    if let houseNumber = node.tags.addrHouseNumber {
      tempAddress += houseNumber
    }

    if let street = node.tags.addrStreet {
      if !tempAddress.isEmpty {
        tempAddress += " "
      }
      tempAddress += street
    }

    if let city = node.tags.addrCity {
      if !tempAddress.isEmpty {
        tempAddress += "\n"
      }
      tempAddress += city
    }

    if let postCode = node.tags.addrPostCode {
      if !tempAddress.isEmpty {
        tempAddress += "\n"
      }
      tempAddress += postCode
    }

    address = (!tempAddress.isEmpty) ? tempAddress : nil
  }

}

extension NodeViewModel: Equatable {

  static func ==(lhs: NodeViewModel, rhs: NodeViewModel) -> Bool {
    lhs.id == rhs.id
  }

}
