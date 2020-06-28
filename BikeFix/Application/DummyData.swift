import Foundation

enum DummyData {

  static let shopNode = Node(
    id: 123,
    lat: 45,
    lon: -93,
    timestamp: "2020-05-02T07:39:39Z",
    user: "ebelinski",
    uid: 123,
    version: 5,
    changeset: 82012168,
    tags: Node.Tags(
      name: "Eugene's Bike Shop",
      description: "A small bike shop.",
      amenity: nil,
      shop: "bicycle",
      brand: nil,
      openingHours: "Monday–Friday 10am–8pm",
      note: "This location has bicycles, clothing, and bike accessories.",
      source: nil,
      serviceBicycleChainTool: nil,
      website: "https://ebelinski.com",
      phone: "+1 555 543 2123",
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
    timestamp: "2020-05-02T07:39:39Z",
    user: "ebelinski",
    uid: 123,
    version: 5,
    changeset: 82012168,
    tags: Node.Tags(
      name: "A repair station",
      description: "Just an ordinary bike repair station",
      amenity: "bicycle_repair_station",
      shop: nil,
      brand: "Dero",
      openingHours: nil,
      note: "It is behind the red building.",
      source: "osmsync:dero",
      serviceBicycleChainTool: "yes",
      website: nil,
      phone: nil,
      addrCity: nil,
      addrHouseNumber: nil,
      addrPostCode: nil,
      addrStreet: nil
    )
  )

}
