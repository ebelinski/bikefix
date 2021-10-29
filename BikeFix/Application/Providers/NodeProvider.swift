import Foundation
import MapKit
import SwiftUI

class NodeProvider: ObservableObject {

  enum DataError: Error { case generic }

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

  // MARK: - Public methods

  func refreshData(forRegion region: MKCoordinateRegion) {
    log.info("Region: \(region)")
    loading = true

    Task {
      do {
        let nodes = try await getNodes(forRegion: region)
        self.loading = false
        self.nodes = nodes
      } catch {
        self.loading = false
      }
    }
  }

  private func getNodes(forRegion region: MKCoordinateRegion) async throws -> [Node] {
    let url = getRequestUrl(forRegion: region)

    log.info("URL: \(url)")

    let (resultingData, _) = try await URLSession.shared.data(from: url)

    do {
      let response = try JSONDecoder().decode(NodeResponse.self, from: resultingData)
      log.info("Elements count: \(response.elements.count)")
      return response.elements
    } catch let error {
      log.error(error.localizedDescription)
      throw DataError.generic
    }
  }

  private func getRequestUrl(forRegion region: MKCoordinateRegion) -> URL {
    let southWestLat = region.southWest.latitude
    let southWestLon = region.southWest.longitude

    let northEastLat = region.northEast.latitude
    let northEastLon = region.northEast.longitude

    let data = "data=[out:json][timeout:25]"
    let box = "[bbox:\(southWestLat),\(southWestLon),\(northEastLat),\(northEastLon)];"
    let node = "(node[amenity=bicycle_repair_station];node[shop=bicycle];);"
    let meta = "out%20meta;"

    let endpoint = "\(dataEndpoint)?\(data)\(box)\(node)\(meta)"

    return URL(string: endpoint)!
  }

}
