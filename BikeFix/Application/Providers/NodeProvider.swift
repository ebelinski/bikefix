import Foundation
import MapKit
import Combine
import SwiftUI

class NodeProvider: ObservableObject {

  // MARK: - Public properties

  @Published var nodes: [Node] = []
  @Published var loading = false

  // MARK: - Private properties

  @AppStorage(SettingsKey.apiBase.rawValue)
  private var apiBase = SettingsDefault.apiBase

  /// Computed property, because the user could change their preference
  private var dataEndpoint: String {
    "https://\(apiBase.rawValue)/api/interpreter"
  }

  private var task: URLSessionDataTask?

  // MARK: - Public methods

  func refreshData(forRegion region: MKCoordinateRegion) {
    log.info("Region: \(region)")
    loading = true

    let southWestLat = region.southWest.latitude
    let southWestLon = region.southWest.longitude

    let northEastLat = region.northEast.latitude
    let northEastLon = region.northEast.longitude

    let data = "data=[out:json][timeout:25]"
    let box = "[bbox:\(southWestLat),\(southWestLon),\(northEastLat),\(northEastLon)];"
    let node = "(node[amenity=bicycle_repair_station];node[shop=bicycle];);"
    let meta = "out%20meta;"
    let endpoint = "\(dataEndpoint)?\(data)\(box)\(node)\(meta)"

    let url = URL(string: endpoint)!

    task?.cancel()

    log.info("URL: \(url)")
    task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        log.error(error.localizedDescription)
        return
      }

      guard let data = data else {
        log.error("Error: data is nil")
        return
      }

      do {
        let response = try JSONDecoder().decode(NodeResponse.self, from: data)
        log.info("Elements count: \(response.elements.count)")
        DispatchQueue.main.async {
          self.loading = false
          self.nodes = response.elements
        }
      } catch let error {
        log.error(error.localizedDescription)
        DispatchQueue.main.async {
          self.loading = false
        }
      }
    }

    task?.resume()
  }

}
