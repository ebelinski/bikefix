import Foundation
import MapKit
import Contacts

class NodeAnnotation: NSObject, MKAnnotation {

  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(nodeVM: NodeViewModel) {
    self.title = nodeVM.name
    self.coordinate = nodeVM.location

    super.init()
  }

  var subtitle: String? {
    return nil
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

  var markerTintColor: UIColor  {
    return UIColor.bikefixPrimary
  }

  var image: UIImage {
    UIImage(systemName: "wrench.fill")!
  }
}
