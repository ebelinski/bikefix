import SwiftUI

struct Map: View {

  @State var nodeViewModels: [NodeViewModel] = []

  var body: some View {
    MapView(nodeViewModels: $nodeViewModels)
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    Map()
  }
}
#endif
