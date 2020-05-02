import SwiftUI
import MapKit

struct NodeDetails: View {

  // MARK: - Environment

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Bindings

  // MARK: - State

  // MARK: - Instance variables

  var nodeVM: NodeViewModel

  // MARK: - Body view

  var body: some View {
    NavigationView {
      Form {
        if nodeVM.address != nil {
          Section(header: Text("Address")) {
            Text(nodeVM.address!)
          }
        }

        Section {
          NavigationLink(destination: NodeDetailsRawData(nodeVM: nodeVM)) {
            Text("Raw Data")
          }
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text(nodeVM.name), displayMode: .large)
      .navigationBarItems(trailing: doneButton)
    }
  }

  // MARK: - Navigation button views

  var doneButton: some View {
    Button(action: {
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Text("Done")
    }
    .accentColor(Color.bikefixPrimary)
    .hoverEffect()
  }

  // MARK: - Other views

  // MARK: - Methods

}

#if DEBUG
struct NodeDetails_Previews: PreviewProvider {
  static var previews: some View {
    NodeDetails(nodeVM: NodeViewModel(node: DummyData.shopNode))
  }
}
#endif
