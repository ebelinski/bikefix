import SwiftUI

struct Settings: View {

  @State var showBikeFixStations = true
  @State var showBikeShops = true

  var body: some View {
    NavigationView {
      Form {
        Section {
          Toggle(isOn: $showBikeFixStations) {
            Text("Show bike fix stations")
          }
          Toggle(isOn: $showBikeShops) {
            Text("Show bike shops")
          }
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text("Settings"), displayMode: .large)
    }
  }

}

#if DEBUG
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    Settings()
  }
}
#endif