import Foundation
import MapKit
import Combine

class NodeProvider: NSObject, ObservableObject {

  var objectWillChange = PassthroughSubject<Void, Never>()

  @Published var nodes: [Node] = [] {
    willSet {
      objectWillChange.send()
    }
  }

  let baseEndpoint = "https://www.overpass-api.de/api/"
  var task: URLSessionDataTask?

  func getData(forRegion region: MKCoordinateRegion) {
    // Kind of a fuzzy calculation, deliberately larger than it needs to be
    let topLeftLatitude = region.center.latitude - region.span.latitudeDelta
    let topLeftLongitude = region.center.longitude - region.span.longitudeDelta

    let bottomRightLatitude = region.center.latitude + region.span.latitudeDelta
    let bottomRightLongitude = region.center.longitude + region.span.longitudeDelta

    let data = "data=[out:json];"
    let node = "node[amenity=bicycle_repair_station]"
    let box = "(\(topLeftLatitude),\(topLeftLongitude),\(bottomRightLatitude),\(bottomRightLongitude));"
    let meta = "out%20meta;"
    let endpoint = "\(baseEndpoint)interpreter?\(data)\(node)\(box)\(meta)"

    let url = URL(string: endpoint)!

    task?.cancel()

    task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        print("Error: \(error.localizedDescription)")
        return
      }

      guard let data = data else {
        print("Error: data is nil")
        return
      }

      do {
        let response = try JSONDecoder().decode(NodeResponse.self, from: data)
        DispatchQueue.main.async {
          self.nodes = response.elements
        }
      } catch let error {
        print("\(error)")
      }
    }

    task?.resume()
  }

}
