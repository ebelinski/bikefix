import Foundation
import MapKit

struct NodeViewModel: Equatable {
  static func ==(lhs: NodeViewModel, rhs: NodeViewModel) -> Bool {
    lhs.id == rhs.id
  }

  let id: Int
  let name: String
  let location: CLLocationCoordinate2D
}
