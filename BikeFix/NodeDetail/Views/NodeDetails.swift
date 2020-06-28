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
    NavigationView {
      Form {
        // MARK: - Section: Information
        Section(header: Text("Information")) {
          HStack {
            Text("Type: \((nodeVM.kind == .bicycleShop) ? "Bike shop" : "Bike fix station")")
            Spacer()
            Image(systemName: (nodeVM.kind == .bicycleShop) ? "cart.fill" : "wrench.fill")
          }

          if nodeVM.node.tags.brand != nil {
            Text("Brand: \(nodeVM.node.tags.brand ?? "")")
          }

          if nodeVM.node.tags.note != nil {
            Text("Note: \(nodeVM.node.tags.note ?? "")")
          }

          if nodeVM.node.tags.serviceBicycleChainTool != nil {
            Text("Service bicycle chain tool: \(nodeVM.node.tags.serviceBicycleChainTool ?? "")")
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
              self.openInAppleMaps(coordinates: self.nodeVM.location, name: self.nodeVM.name)
            }
          }
        }

        // MARK: - Section: Address
        if nodeVM.address != nil {
          Section(header: Text("Address")) {
            HStack {
              Text(nodeVM.address!)
              Spacer()
              CopyButton(text: nodeVM.address!)
            }

            HStack {
              Text("Open in:")

              Button("Google Maps") {
                self.openInGoogleMaps(address: self.nodeVM.address!)
              }

              Button("Apple Maps") {
                self.openInAppleMaps(address: self.nodeVM.address!)
              }
            }
          }
        }

        // MARK: - Section: Phone
        if nodeVM.node.tags.phone != nil {
          Section(header: Text("Phone")) {
            HStack {
              Image(systemName: "phone")
                .foregroundColor(Color.bikefixPrimary)

              Button(nodeVM.node.tags.phone!) {
                if let url = URL(string: "tel://\(self.nodeVM.sanitizedPhoneNumber!)") {
                  UIApplication.shared.open(url)
                }
              }
            }
          }
        }

        // MARK: - Section: Website
        if nodeVM.node.tags.website != nil {
          Section(header: Text("Website")) {
            HStack {
              Image(systemName: "globe")
                .foregroundColor(Color.bikefixPrimary)

              Button(nodeVM.node.tags.website!) {
                if let url = URL(string: self.nodeVM.node.tags.website!) {
                  UIApplication.shared.open(url)
                }
              }
            }
          }
        }

        // MARK: - Section: Miscellaneous
        Section(header: Text("Miscellaneous")) {
          if nodeVM.node.user != nil {
            Text("User: \(nodeVM.node.user ?? "") (\(nodeVM.node.uid ?? -1))")
          }

          Text("Last updated: \(nodeVM.lastUpdated)")

          if nodeVM.node.version != nil {
            Text("Version: \(nodeVM.node.version ?? -1)")
          }

          if nodeVM.node.changeset != nil {
            Text("Changeset: \(nodeVM.node.changeset ?? -1)")
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
        log.error(error)
        return
      }

      guard let placemarks = placemarks else { return }
      let geocodedPlacemark = placemarks[0]
      let placemark = MKPlacemark(
        coordinate: geocodedPlacemark.location!.coordinate,
        addressDictionary: geocodedPlacemark.addressDictionary! as? [String: AnyObject]
      )

      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = geocodedPlacemark.name

      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

      let currentLocationMapItem = MKMapItem.forCurrentLocation()
      MKMapItem.openMaps(with: [currentLocationMapItem, mapItem],
                         launchOptions: launchOptions)
    }
  }

}

#if DEBUG
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
#endif
