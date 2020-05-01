import Foundation
import MapKit

class NodeAnnotationMarkerView: MKMarkerAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let annotation = newValue as? NodeAnnotation else { return }

      canShowCallout = true
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      glyphImage = annotation.image
      glyphTintColor = UIColor.softBackground
      markerTintColor = annotation.markerTintColor

      if let subtitle = annotation.subtitle {
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        detailLabel.text = subtitle
        detailCalloutAccessoryView = detailLabel
      }
    }
  }

}
