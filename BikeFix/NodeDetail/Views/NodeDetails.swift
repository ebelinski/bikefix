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
        }

        Section(header: Text("Coordinates")) {
          Text("(\(nodeVM.location.latitude), \(nodeVM.location.longitude))")

          Button(action: {
            self.openInGoogleMaps(coordinates: self.nodeVM.location)
          }) {
            HStack {
              Image(systemName: "map")
                .foregroundColor(Color.bikefixPrimary)
              Text("Open coordinates in Google Maps")
            }
          }

          Button(action: {
            print("apple maps")
          }) {
            HStack {
              Image(systemName: "map.fill")
                .foregroundColor(Color.bikefixPrimary)
              Text("Open coordinates in Apple Maps")
            }
          }
        }

        if nodeVM.address != nil {
          Section(header: Text("Address")) {
            Text(nodeVM.address!)

            Button(action: {
              self.openInGoogleMaps(address: self.nodeVM.address!)
            }) {
              HStack {
                Image(systemName: "map")
                  .foregroundColor(Color.bikefixPrimary)
                Text("Open address in Google Maps")
              }
            }

            Button(action: {
              self.openInAppleMaps(address: self.nodeVM.address!)
            }) {
              HStack {
                Image(systemName: "map.fill")
                  .foregroundColor(Color.bikefixPrimary)
                Text("Open address in Apple Maps")
              }
            }
          }
        }

        Section {
          NavigationLink(destination: NodeDetailsRawData(nodeVM: nodeVM)) {
            Text("Raw Data")
          }
        }
      }
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
        print(error)
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
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

      NodeDetails(nodeVM: NodeViewModel(node: DummyData.stationNode))
      .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
  }
}
#endif
