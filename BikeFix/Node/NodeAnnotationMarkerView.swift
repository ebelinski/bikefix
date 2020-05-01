import Foundation
import MapKit

class NodeAnnotationMarkerView: MKMarkerAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let annotation = newValue as? NodeAnnotation else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      markerTintColor = annotation.markerTintColor
      glyphImage = annotation.image
    }
  }

}
