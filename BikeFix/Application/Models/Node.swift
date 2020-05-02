import Foundation

struct Node: Codable {

  struct Tags: Codable {

    let name: String?
    let description: String?
    let amenity: String?
    let shop: String?
    let brand: String?
    let openingHours: String?
    let note: String?
    let source: String?
    let serviceBicycleChainTool: String?

    let addrCity: String?
    let addrHouseNumber: String?
    let addrPostCode: String?
    let addrStreet: String?

    enum CodingKeys: String, CodingKey {
      case name
      case description
      case amenity
      case shop
      case brand
      case openingHours = "opening_hours"
      case note
      case source
      case serviceBicycleChainTool = "service:bicycle:chain_tool"

      case addrCity = "addr:city"
      case addrHouseNumber = "addr:housenumber"
      case addrPostCode = "addr:postcode"
      case addrStreet = "addr:street"
    }

  }

  let id: Int
  let lat: Double
  let lon: Double

  let timestamp: String
  let user: String?
  let uid: Int?
  
  let tags: Tags

  var toString: String {
    get {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      guard let data = try? encoder.encode(self) else { return "" }
      return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
  }

}
