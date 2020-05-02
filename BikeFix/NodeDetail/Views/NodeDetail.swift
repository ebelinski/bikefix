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
        Section(header: Text("Foo")) {
          Text("Bar")
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text("Details"), displayMode: .large)
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
