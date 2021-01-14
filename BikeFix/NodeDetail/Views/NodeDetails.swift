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
            HStack {
              Text("Brand: \(nodeVM.node.tags.brand!)")
              Spacer()
              CopyButton(text: nodeVM.node.tags.brand!)
            }
          }

          if nodeVM.node.tags.note != nil {
            HStack {
              Text("Note: \(nodeVM.node.tags.note!)")
              Spacer()
              CopyButton(text: nodeVM.node.tags.note!)
            }
          }

          if nodeVM.node.tags.serviceBicycleChainTool != nil {
            Text("Service bicycle chain tool: \(nodeVM.node.tags.serviceBicycleChainTool!)")
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
              self.openInAppleMaps(coordinates: self.nodeVM.location,
                                   name: self.nodeVM.name)
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
              Button(action: {
                if let url = URL(string: "tel://\(self.nodeVM.sanitizedPhoneNumber!)") {
                  UIApplication.shared.open(url)
                }
              }) {
                HStack {
                  Image(systemName: "phone")
                  Text(nodeVM.node.tags.phone!)
                }
              }

              Spacer()

              CopyButton(text: nodeVM.node.tags.phone!)
            }
          }
        }

        // MARK: - Section: Website
        if nodeVM.node.tags.website != nil {
          Section(header: Text("Website")) {
            HStack {
              Button(action: {
                if let url = URL(string: self.nodeVM.node.tags.website!) {
                  UIApplication.shared.open(url)
                }
              }) {
                HStack {
                  Image(systemName: "globe")
                  Text(nodeVM.node.tags.website!)
                }
              }

              Spacer()

              CopyButton(text: nodeVM.node.tags.website!)
            }
          }
        }

        // MARK: - Section: Miscellaneous
        Section(header: Text("Miscellaneous")) {
          if nodeVM.node.user != nil && nodeVM.node.uid != nil {
            HStack {
              Text("User: \(nodeVM.node.user!) (\(nodeVM.node.uid!))")
              Spacer()
              CopyButton(text: "\(nodeVM.node.user!) (\(nodeVM.node.uid!))")
            }
          }

          HStack {
            Text("Last updated: \(nodeVM.lastUpdated)")
            Spacer()
            CopyButton(text: nodeVM.lastUpdated)
          }

          if nodeVM.node.version != nil {
            HStack {
              Text("Version: \(nodeVM.node.version!)")
              Spacer()
              CopyButton(text: "\(nodeVM.node.version!)")
            }
          }

          if nodeVM.node.changeset != nil {
            HStack {
              Text("Changeset: \(nodeVM.node.changeset!)")
              Spacer()
              CopyButton(text: "\(nodeVM.node.changeset!)")
            }
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
