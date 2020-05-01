import SwiftUI

struct Settings: View {

  @EnvironmentObject var userSettings: UserSettings

  var body: some View {
    NavigationView {
      Form {
        Section {
          Toggle(isOn: $userSettings.showBicycleRepairStations) {
            Text("Show bike fix stations")
          }
          Toggle(isOn: $userSettings.showBicycleShops) {
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
