import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider
  @EnvironmentObject var userSettings: UserSettings

  // MARK: - Bindings

  @Binding var nodes: [Node]
  @Binding var openedNodeVM: NodeViewModel?
  @Binding var displayingLocationAuthRequest: Bool
  @Binding var shouldNavigateToUserLocation: Bool

  // MARK: - Instance variables

  let locationManager = CLLocationManager()
  var previouslySearchedRegion: MKCoordinateRegion?

  // MARK: - Instance methods

  func makeUIView(context: Context) -> MKMapView {
    let map = MKMapView()

    map.delegate = context.coordinator
    map.mapType = .mutedStandard
    map.showsScale = true
    map.showsCompass = true
    map.showsUserLocation = true

    map.register(
      NodeAnnotationMarkerView.self,
      forAnnotationViewWithReuseIdentifier: NodeAnnotationMarkerView.identifier
    )

    return map
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    let existingAnnotations = uiView.annotations.compactMap { $0 as? NodeAnnotation }
    let existingNodeVMs = existingAnnotations.map(\.nodeVM)
    let allNodeVMs = nodes.map { NodeViewModel(node: $0) }
    let newNodeVMs = allNodeVMs.filter { !existingNodeVMs.contains($0) }
    let newAnnotations = newNodeVMs.map { NodeAnnotation(nodeVM: $0) }

    uiView.addAnnotations(newAnnotations)

    // TODO: Improve this naming
    let annotationsIntermediateStep = uiView.annotations.compactMap { $0 as? NodeAnnotation }

    let stationAnnotations = annotationsIntermediateStep.filter {
      $0.nodeVM.kind == .bicycleRepairStation
    }

    let shopAnnotations = annotationsIntermediateStep.filter {
      $0.nodeVM.kind == .bicycleShop
    }

    if !userSettings.showBicycleRepairStations {
      uiView.removeAnnotations(stationAnnotations)
    }

    if !userSettings.showBicycleShops {
      uiView.removeAnnotations(shopAnnotations)
    }

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

    let region = MKCoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.02,
                             longitudeDelta: 0.02)
    )
    map.setRegion(region, animated: true)
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject, MKMapViewDelegate {

    var control: MapViewRepresentable

    init(_ control: MapViewRepresentable) {
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

    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard let annotation = annotation as? NodeAnnotation else { return nil }

      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NodeAnnotationMarkerView.identifier) as? NodeAnnotationMarkerView
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
      let newVisibleRegion = mapView.region
      log.info("Region changed to: \(newVisibleRegion)")

      // Don't search if new region isn't close enough
      guard newVisibleRegion.span.latitudeDelta < 2.0 else {
        log.info("Cancelling search: Region is too far away")
        return
      }

      // Don't search if new region is fully contained in existing search region
      if let previouslySearchedRegion = control.previouslySearchedRegion {
        if previouslySearchedRegion.fullyContains(region: newVisibleRegion) {
          log.info("Cancelling search: Previous region fully contains new one")
          return
        }
      }

      // Get a larger region to search so nearby but out-of-view results are
      // displayed without delay on navigation
      let largerNewRegion = newVisibleRegion.largerRegion

      control.nodeProvider.getData(forRegion: largerNewRegion)
      control.previouslySearchedRegion = largerNewRegion
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
      guard let view = view as? NodeAnnotationMarkerView else { return }
      guard let annotation = view.annotation as? NodeAnnotation else { return }
      self.control.openedNodeVM = annotation.nodeVM
    }

  }

}
