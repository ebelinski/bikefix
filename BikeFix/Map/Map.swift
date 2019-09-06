import SwiftUI

struct Map: View {

  @EnvironmentObject var nodeProvider: NodeProvider

  var body: some View {
    MapView(nodes: $nodeProvider.nodes)
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    Map()
  }
}
#endif
