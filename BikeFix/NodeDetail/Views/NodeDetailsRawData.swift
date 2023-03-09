import SwiftUI
import MapKit

struct NodeDetailsRawData: View {

  // MARK: - Instance variables

  var nodeVM: NodeViewModel

  // MARK: - Body view

  var body: some View {
    Form {
      Section(header: Text("JSON")) {
        HStack {
          Text(nodeVM.node.toString)
            .font(.system(.body, design: .monospaced))

          Spacer()

          VStack {
            CopyButton(text: nodeVM.node.toString)
              .padding(.top)
            Spacer()
          }
        }
      }
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle(Text("Raw Data"))
  }

}

struct NodeDetailsRawData_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      NodeDetailsRawData(nodeVM: NodeViewModel(node: DummyData.shopNode))
    }
    .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
  }
}
