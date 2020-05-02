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

}
