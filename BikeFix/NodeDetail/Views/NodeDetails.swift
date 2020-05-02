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

        Section(header: Text("Coordinates")) {
          Text("(\(nodeVM.location.latitude), \(nodeVM.location.longitude))")

          HStack {
            Image(systemName: "map")
              .foregroundColor(Color.bikefixPrimary)
            Text("Open in:")

            Button("Google Maps", action: {
              self.openInGoogleMaps(coordinates: self.nodeVM.location)
            })

            Button("Apple Maps", action: {
              print("apple maps")
            })
          }
        }

        if nodeVM.address != nil {
          Section(header: Text("Address")) {
            Text(nodeVM.address!)

            HStack {
              Image(systemName: "map")
                .foregroundColor(Color.bikefixPrimary)
              Text("Open in:")

              Button("Google Maps", action: {
                self.openInGoogleMaps(address: self.nodeVM.address!)
              })

              Button("Apple Maps", action: {
                self.openInAppleMaps(address: self.nodeVM.address!)
              })
            }
          }
        }

        Section(header: Text("Miscellaneous")) {
          if nodeVM.node.user != nil {
            Text("User: \(nodeVM.node.user ?? "") (\(nodeVM.node.uid ?? -1))")
          }

          Text("Last updated: \(nodeVM.lastUpdated)")
        }

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

  func openInGoogleMaps(coordinates: CLLocationCoordinate2D) {
    guard let URL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(coordinates.latitude),\(coordinates.longitude)") else { return }
    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
  }

  func openInGoogleMaps(address: String) {
    guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    guard let URL = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)") else { return }
    UIApplication.shared.open(URL, options: [:], completionHandler: nil)
  }

  func openInAppleMaps(address: String) {
    CLGeocoder().geocodeAddressString(address) { placemarks, error in
      if let error = error {
        log.error(error)
        return
      }

      guard let placemarks = placemarks else { return }
      let geocodedPlacemark = placemarks[0]
      let placemark = MKPlacemark(coordinate: geocodedPlacemark.location!.coordinate,
                                  addressDictionary: geocodedPlacemark.addressDictionary! as? [String: AnyObject])

      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = geocodedPlacemark.name

      let launchOptions = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving,
                                       forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
      let currentLocationMapItem = MKMapItem.forCurrentLocation()
      MKMapItem.openMaps(with: [currentLocationMapItem, mapItem],
                         launchOptions: launchOptions as? [String: AnyObject])
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
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
  }
}
#endif
