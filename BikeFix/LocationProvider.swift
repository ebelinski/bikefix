import Foundation
import MapKit

protocol LocationProviderDelegate {
  func displayLocations(locations: [Location])
}

class LocationProvider {

  let baseEndpoint = "https://www.overpass-api.de/api/"
  var delegate: LocationProviderDelegate?
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
        let response = try JSONDecoder().decode(LocationResponse.self, from: data)
        DispatchQueue.main.async {
          self.delegate?.displayLocations(locations: response.elements)
        }
      } catch let error {
        print("\(error)")
      }
    }

    task?.resume()
  }

}
