import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

  @Binding var nodeViewModels: [NodeViewModel]

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()
    map.delegate = context.coordinator
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.removeAnnotations(uiView.annotations)
    let newAnnotations = nodeViewModels.map { NodeAnnotation(nodeViewModel: $0) }
    uiView.addAnnotations(newAnnotations)
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

  }

}
