import MapKit

extension MKCoordinateRegion {
  var northWest: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: center.latitude + span.latitudeDelta / 2,
      longitude: center.longitude - span.longitudeDelta / 2
    )
  }

  var northEast: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: center.latitude + span.latitudeDelta / 2,
      longitude: center.longitude + span.longitudeDelta / 2
    )
  }

  var southWest: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: center.latitude - span.latitudeDelta / 2,
      longitude: center.longitude - span.longitudeDelta / 2
    )
  }

  var southEast: CLLocationCoordinate2D {
    CLLocationCoordinate2D(
      latitude: center.latitude - span.latitudeDelta / 2,
      longitude: center.longitude + span.longitudeDelta / 2
    )
  }

  // A region with the same center but double the deltas
  var largerRegion: MKCoordinateRegion {
    let newSpan = MKCoordinateSpan(latitudeDelta: span.latitudeDelta * 2,
                                   longitudeDelta: span.longitudeDelta * 2)
    return MKCoordinateRegion(center: center, span: newSpan)
  }

  // Returns true if the region is completely contained in this region
  func fullyContains(region: MKCoordinateRegion) -> Bool {
    northWest.latitude >= region.northWest.latitude
      && northWest.longitude <= region.northWest.longitude
      && southEast.latitude <= region.southEast.latitude
      && southEast.longitude >= region.southEast.longitude
  }
}
