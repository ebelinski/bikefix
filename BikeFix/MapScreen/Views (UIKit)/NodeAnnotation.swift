import Foundation
import MapKit
import Contacts

class NodeAnnotation: NSObject, MKAnnotation {

  let title: String?
  let subtitle: String?
  let coordinate: CLLocationCoordinate2D
  let image: UIImage
  let markerTintColor: UIColor

  let nodeVM: NodeViewModel

  init(nodeVM: NodeViewModel) {
    title = nodeVM.name
    subtitle = nil
    coordinate = nodeVM.location
    image = (nodeVM.kind == .bicycleShop)
      ? UIImage(systemName: "cart.fill")!
      : UIImage(systemName: "wrench.fill")!
    markerTintColor = (nodeVM.kind == .bicycleShop)
      ? UIColor.bikefixPrimary
      : UIColor.bikefixSecondary

    self.nodeVM = nodeVM

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
