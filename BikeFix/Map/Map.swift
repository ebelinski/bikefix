import SwiftUI

struct Map: View {

  @EnvironmentObject var nodeProvider: NodeProvider

  var body: some View {
    ZStack {
      MapView(nodes: $nodeProvider.nodes)

      HStack {
        Spacer()
        VStack {
          Spacer()
          Button(action: {
            print("Locate Me")
          }) {
            Image(systemName: "location")
              .imageScale(.large)
              .accessibility(label: Text("Locate Me"))
              .padding()
          }
        }
      }
    }
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    Map()
  }
}
#endif
