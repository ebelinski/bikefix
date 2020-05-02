import SwiftUI
import MapKit

struct NodeDetailsRawData: View {

  // MARK: - Instance variables

  var nodeVM: NodeViewModel

  // MARK: - Body view

  var body: some View {
    Form {
      Section {
        Text("\(nodeVM.node.toString)")
          .font(.system(.body, design: .monospaced))
      }
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle(Text("Raw Data"))
  }

}

#if DEBUG
struct NodeDetailsRawData_Previews: PreviewProvider {
  static var previews: some View {
    NodeDetailsRawData(nodeVM: NodeViewModel(node: DummyData.shopNode))
  }
}
#endif
