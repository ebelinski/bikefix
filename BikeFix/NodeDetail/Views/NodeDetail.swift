import SwiftUI
import MapKit

struct NodeDetail: View {

  // MARK: - Environment

  @EnvironmentObject var nodeProvider: NodeProvider

  // MARK: - Bindings

  // MARK: - State

  // MARK: - Instance variables

  var nodeVM: NodeViewModel

  // MARK: - Body view

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Foo")) {
          Text("Bar")
        }
      }
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle(Text(nodeVM.name), displayMode: .large)
  }

  // MARK: - Other views

  // MARK: - Methods

}
