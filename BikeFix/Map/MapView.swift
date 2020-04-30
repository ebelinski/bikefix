import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

  @EnvironmentObject var nodeProvider: NodeProvider

  @Binding var nodes: [Node]
  @Binding var currentlyDisplayingLocationAuthorizationRequest: Bool
  @Binding var shouldNavigateToUserLocation: Bool

  let locationManager = CLLocationManager()

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()
    map.delegate = context.coordinator
    map.showsScale = true
    map.showsCompass = true
    map.showsUserLocation = true
    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.removeAnnotations(uiView.annotations)

    let annotations: [MKPointAnnotation] = nodes.map {
      let annotation = MKPointAnnotation()
      annotation.coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lon)
      annotation.title = $0.tags.name ?? $0.tags.description ?? $0.tags.brand ?? "Unnamed"
      return annotation
    }

    uiView.addAnnotations(annotations)

    print("2️⃣2️⃣ shouldNavigateToUserLocation: \(shouldNavigateToUserLocation)")
    if !currentlyDisplayingLocationAuthorizationRequest && shouldNavigateToUserLocation {
      moveToUserLocation(map: uiView)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: Location -

  private func moveToUserLocation(map: MKMapView) {
    guard let location = locationManager.location else { return }

    let region = MKCoordinateRegion(center: location.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.02,
                                                           longitudeDelta: 0.02))
    map.setRegion(region, animated: true)
  }

  // MARK: Coordinator -

  final class Coordinator: NSObject, MKMapViewDelegate {

    let identifier = "Annotation"

    var control: MapView

    init(_ control: MapView) {
      self.control = control
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
      control.shouldNavigateToUserLocation = false
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
