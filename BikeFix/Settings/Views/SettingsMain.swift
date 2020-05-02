import SwiftUI

struct SettingsMain: View {

  // MARK: - Environment

  @EnvironmentObject var userSettings: UserSettings

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Body view

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

}

#if DEBUG
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    SettingsMain()
  }
}
#endif
