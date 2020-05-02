import Foundation

enum DummyData {

  static let shopNode = Node(
    id: 123,
    lat: 45,
    lon: -93,
    tags: Node.Tags(
      name: "Eugene's Bike Shop",
      description: "A small bike shop.",
      amenity: nil,
      shop: "bicycle",
      brand: nil,
      openingHours: "Monday–Friday 10am–8pm",
      addrCity: "Minneapolis",
      addrHouseNumber: "123",
      addrPostCode: "55414",
      addrStreet: "Main St."
    )
  )

  static let stationNode = Node(
    id: 123,
    lat: 45,
    lon: -93,
    tags: Node.Tags(
      name: "A repair station",
      description: "Just an ordinary bike repair station",
      amenity: "bicycle_repair_station",
      shop: nil,
      brand: "Dero",
      openingHours: nil,
      addrCity: nil,
      addrHouseNumber: nil,
      addrPostCode: nil,
      addrStreet: nil
    )
  )

}
