import Foundation
import MapKit

class NodeAnnotationInfoView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let annotation = newValue as? NodeAnnotation else { return }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
      mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
      rightCalloutAccessoryView = mapsButton

      image = annotation.image

      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = annotation.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }

}
