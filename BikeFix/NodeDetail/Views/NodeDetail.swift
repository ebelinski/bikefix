import SwiftUI
import MapKit

struct NodeDetail: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider

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


        Section(header: Text("Raw")) {
          Text("Raw data: \(nodeVM.node.toString)")
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
