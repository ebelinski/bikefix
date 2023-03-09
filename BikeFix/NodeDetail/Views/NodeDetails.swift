import SwiftUI
import MapKit

struct NodeDetails: View {

  // MARK: - Environment

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Bindings

  // MARK: - State

  // MARK: - Instance variables

  var nodeVM: NodeViewModel

  // MARK: - Body view

  var body: some View {
    NavigationStack {
      Form {
        // MARK: - Section: Information
        Section(header: Text("Information")) {
          HStack {
            Text("Type: ").fontWeight(.bold) + Text((nodeVM.kind == .bicycleShop) ? "Bike shop" : "Bike fix station")
            Spacer()
            Image(systemName: (nodeVM.kind == .bicycleShop) ? "cart.fill" : "wrench.fill")
          }

          if let brand = nodeVM.node.tags.brand {
            SimpleDetailCell(title: "Brand", content: brand)
          }

          if let note = nodeVM.node.tags.note {
            SimpleDetailCell(title: "Note", content: note)
          }

          if let serviceBicycleChainTool = nodeVM.node.tags.serviceBicycleChainTool {
            Text("Service bicycle chain tool: \(serviceBicycleChainTool)")
          }
        }

        // MARK: - Section: Coordinate
        Section(header: Text("Coordinate")) {
          HStack {
            Text(nodeVM.coordinate)
            Spacer()
            CopyButton(text: nodeVM.coordinate)
          }

          HStack {
            Text("Open in:")

            Button("Google Maps") {
              self.openInGoogleMaps(coordinates: self.nodeVM.location)
            }

            Button("Apple Maps") {
              self.openInAppleMaps(
                coordinates: self.nodeVM.location,
                name: self.nodeVM.name
              )
            }
          }
        }

        // MARK: - Section: Address
        if let address = nodeVM.address {
          Section(header: Text("Address")) {
            HStack {
              Text(address)
              Spacer()
              CopyButton(text: address)
            }

            HStack {
              Text("Open in:")

              Button("Google Maps") {
                self.openInGoogleMaps(address: address)
              }

              Button("Apple Maps") {
                self.openInAppleMaps(address: address)
              }
            }
          }
        }

        // MARK: - Section: Phone
        if let phone = nodeVM.node.tags.phone {
          Section(header: Text("Phone")) {
            HStack {
              Button(action: {
                if let url = URL(string: "tel://\(self.nodeVM.sanitizedPhoneNumber!)") {
                  UIApplication.shared.open(url)
                }
              }) {
                HStack {
                  Image(systemName: "phone")
                  Text(phone)
                }
              }

              Spacer()

              CopyButton(text: phone)
            }
          }
        }

        // MARK: - Section: Website
        if let website = nodeVM.node.tags.website {
          Section(header: Text("Website")) {
            HStack {
              Button(action: {
                if let url = URL(string: website) {
                  UIApplication.shared.open(url)
                }
              }) {
                HStack {
                  Image(systemName: "globe")
                  Text(website)
                }
              }

              Spacer()

              CopyButton(text: website)
            }
          }
        }

        // MARK: - Section: Miscellaneous
        Section(header: Text("Miscellaneous")) {
          if let user = nodeVM.node.user, let uid = nodeVM.node.uid {
            SimpleDetailCell(title: "User", content: "\(user) (\(uid))")
          }

          SimpleDetailCell(title: "Last updated", content: nodeVM.lastUpdated)

          if let version = nodeVM.node.version {
            SimpleDetailCell(title: "Version", content: "\(version)")
          }

          if let changeset = nodeVM.node.changeset {
            SimpleDetailCell(title: "Last updated", content: "\(changeset)")
          }
        }

        // MARK: - Section: Raw Data
        Section {
          NavigationLink(destination: NodeDetailsRawData(nodeVM: nodeVM)) {
            Text("Raw Data")
          }
        }
      }
      .buttonStyle(BorderlessButtonStyle()) // Required to prevent the first button in a list being the only functional button.
      .accentColor(Color.bikefixPrimary)
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text(nodeVM.name), displayMode: .large)
      .navigationBarItems(trailing: doneButton)
    }
  }

  // MARK: - Navigation button views

  var doneButton: some View {
    Button(action: {
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Text("Done")
    }
    .accentColor(Color.bikefixPrimary)
    .hoverEffect()
  }

  // MARK: - Other views

  // MARK: - Methods

  private func openInGoogleMaps(coordinates: CLLocationCoordinate2D) {
    guard let URL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(coordinates.latitude),\(coordinates.longitude)") else { return }
    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
  }

  private func openInGoogleMaps(address: String) {
    guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    guard let URL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)") else { return }
    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
  }

  private func openInAppleMaps(coordinates: CLLocationCoordinate2D, name: String) {
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
    mapItem.name = name

    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

    let currentLocationMapItem = MKMapItem.forCurrentLocation()
    MKMapItem.openMaps(
      with: [currentLocationMapItem, mapItem],
      launchOptions: launchOptions
    )
  }

  private func openInAppleMaps(address: String) {
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
      if let error = error {
        log.error(error.localizedDescription)
        return
      }

      guard let placemarks = placemarks else { return }
      let clPlacemark = placemarks[0]
      let mkPlacemark = MKPlacemark(placemark: clPlacemark)

      let mapItem = MKMapItem(placemark: mkPlacemark)
      mapItem.name = clPlacemark.name

      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

      let currentLocationMapItem = MKMapItem.forCurrentLocation()
      MKMapItem.openMaps(with: [currentLocationMapItem, mapItem],
                         launchOptions: launchOptions)
    }
  }

}

struct NodeDetails_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NodeDetails(nodeVM: NodeViewModel(node: DummyData.shopNode))
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

      NodeDetails(nodeVM: NodeViewModel(node: DummyData.stationNode))
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
  }
}
