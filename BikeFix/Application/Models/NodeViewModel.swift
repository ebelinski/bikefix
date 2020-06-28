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

  var coordinate: String {
    "(\(location.latitude), \(location.longitude))"
  }

  var address: String? {
    var temp = ""

    if let name = node.tags.name {
      temp += name
    }

    if let houseNumber = node.tags.addrHouseNumber {
      if !temp.isEmpty { temp += "\n" }
      temp += houseNumber
    }

    if let street = node.tags.addrStreet {
      if !temp.isEmpty { temp += " " }
      temp += street
    }

    if let city = node.tags.addrCity {
      if !temp.isEmpty { temp += "\n" }
      temp += city
    }

    if let postCode = node.tags.addrPostCode {
      if !temp.isEmpty { temp += "\n" }
      temp += postCode
    }

    return (!temp.isEmpty && temp != node.tags.name) ? temp : nil
  }

  let location: CLLocationCoordinate2D
  let kind: Kind

  var sanitizedPhoneNumber: String? {
    return node.tags.phone?.filter("0123456789+".contains)
  }

  var lastUpdated: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    guard let lastChangedDate = formatter.date(from: node.timestamp) else { return "" }
    formatter.dateFormat = "MMM d, yyyy, h:mm a"
    return formatter.string(from: lastChangedDate)
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
  }

}

extension NodeViewModel: Equatable {

  static func ==(lhs: NodeViewModel, rhs: NodeViewModel) -> Bool {
    lhs.id == rhs.id
  }

}
