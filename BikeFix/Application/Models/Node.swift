import Foundation

struct Node: Codable {

  struct Tags: Codable {
    let name: String?
    let description: String?
    let amenity: String?
    let shop: String?
    let brand: String?
    let opening_hours: String?
  }

  let id: Int
  let lat: Double
  let lon: Double
  let tags: Tags

}
