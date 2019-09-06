import SwiftUI

struct Map: View {

  @EnvironmentObject var nodeProvider: NodeProvider

  var body: some View {
    MapView()
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    Map()
  }
}
#endif
