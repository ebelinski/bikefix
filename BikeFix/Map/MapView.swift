import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider

  // MARK: - Bindings

  @Binding var nodes: [Node]
  @Binding var displayingLocationAuthRequest: Bool
  @Binding var shouldNavigateToUserLocation: Bool

  // MARK: - Instance variables

  let locationManager = CLLocationManager()

  // MARK: - Instance methods

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()

    map.delegate = context.coordinator
    map.mapType = .mutedStandard
    map.showsScale = true
    map.showsCompass = true
    map.showsUserLocation = true

    map.register(NodeAnnotationMarkerView.self,
                 forAnnotationViewWithReuseIdentifier: String(describing: NodeAnnotationMarkerView.self))

    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    let existingAnnotations = uiView.annotations.compactMap { $0 as? NodeAnnotation }
    let existingNodeVMs = existingAnnotations.map(\.nodeVM)
    let allNodeVMs = nodes.map { NodeViewModel(node: $0) }
    let newNodeVMs = allNodeVMs.filter { !existingNodeVMs.contains($0) }
    let newAnnotations = newNodeVMs.map { NodeAnnotation(nodeVM: $0) }

    uiView.addAnnotations(newAnnotations)

    if !displayingLocationAuthRequest && shouldNavigateToUserLocation {
      moveToUserLocation(map: uiView)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: - Location

  private func moveToUserLocation(map: MKMapView) {
    guard let location = locationManager.location else { return }

    let region = MKCoordinateRegion(center: location.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.02,
                                                           longitudeDelta: 0.02))
    map.setRegion(region, animated: true)
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject, MKMapViewDelegate {

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

      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: NodeAnnotationMarkerView.self)) as? NodeAnnotationMarkerView
      if annotationView == nil {
        annotationView = NodeAnnotationMarkerView(
          annotation: annotation,
          reuseIdentifier: String(describing: NodeAnnotationMarkerView.self)
        )
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
