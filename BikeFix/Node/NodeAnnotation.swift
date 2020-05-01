import Foundation
import MapKit
import Contacts

class NodeAnnotation: NSObject, MKAnnotation {

  let title: String?
  let subtitle: String?
  let coordinate: CLLocationCoordinate2D
  let image: UIImage
  let markerTintColor: UIColor

  init(nodeVM: NodeViewModel) {
    self.title = nodeVM.name
    self.subtitle = nil
    self.coordinate = nodeVM.location
    self.image = (nodeVM.kind == .bicycleShop)
      ? UIImage(systemName: "cart.fill")!
      : UIImage(systemName: "wrench.fill")!
    self.markerTintColor = (nodeVM.kind == .bicycleShop)
      ? UIColor.bikefixPrimary
      : UIColor.bikefixSecondary

    super.init()
  }

  var mapItem: MKMapItem? {
    let addressDict = [CNPostalAddressStreetKey: "fdsa"]
    let placemark = MKPlacemark(
      coordinate: coordinate,
      addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }

}
