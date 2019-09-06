import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

  @EnvironmentObject var nodeProvider: NodeProvider

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()
    map.delegate = context.coordinator
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.removeAnnotations(uiView.annotations)

    let annotations: [MKPointAnnotation] = nodeProvider.nodes.map {
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
      annotation.title = $0.tags.name ?? $0.tags.description ?? $0.tags.brand ?? "Unnamed"
      return annotation
    }

    uiView.addAnnotations(annotations)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final class Coordinator: NSObject, MKMapViewDelegate {

    let identifier = "Annotation"

    var control: MapView

    init(_ control: MapView) {
      self.control = control
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let coordinates = view.annotation?.coordinate else { return }
      let span = mapView.region.span
      let region = MKCoordinateRegion(center: coordinates, span: span)
      mapView.setRegion(region, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard let annotation = annotation as? NodeAnnotation else { return nil }

      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
      if annotationView == nil {
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      } else {
        annotationView?.annotation = annotation
      }
      return annotationView
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      let newRegion = mapView.region

      if (newRegion.span.latitudeDelta < 2.0) {
        control.nodeProvider.getData(forRegion: newRegion)
      }
    }

  }

}
