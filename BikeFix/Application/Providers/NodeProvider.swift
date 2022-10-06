import Foundation
import MapKit
import SwiftUI

class NodeProvider: ObservableObject {

  enum DataError: Error { case decodingError }

  // MARK: - Public properties

  @Published var nodes: [Node] = []
  @Published var loading = false

  @AppStorage(SettingsKey.hasLoadedNodesOnce.rawValue)
  var hasLoadedNodesOnce = SettingsDefault.hasLoadedNodesOnce

  // MARK: - Private properties

  @AppStorage(SettingsKey.apiBase.rawValue)
  private var apiBase = SettingsDefault.apiBase

  /// Computed property, because the user could change their preference
  private var dataEndpoint: String {
    "https://\(apiBase.rawValue)/api/interpreter"
  }

  // MARK: - Public methods

  @MainActor func refreshData(forRegion region: MKCoordinateRegion) async {
    log.info("Region: \(region)")
    loading = true

    do {
      nodes = try await getNodes(forRegion: region)
      loading = false
      hasLoadedNodesOnce = true
    } catch {
      log.error(error.localizedDescription)
      loading = false
    }
  }

  @MainActor
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
      throw DataError.decodingError
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
