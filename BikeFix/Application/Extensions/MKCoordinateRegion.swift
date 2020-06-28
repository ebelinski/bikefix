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

}
