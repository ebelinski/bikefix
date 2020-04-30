import Foundation
import MapKit
import Contacts

class NodeAnnotation: NSObject, MKAnnotation {

  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(title: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return "foobar"
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
    return .blue
  }

  var image: UIImage {
    UIImage(systemName: "wrench.fill")!
  }
}
