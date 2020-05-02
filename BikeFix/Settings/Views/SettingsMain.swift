import SwiftUI

struct SettingsMain: View {

  // MARK: - Environment

  @EnvironmentObject var userSettings: UserSettings

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Body view

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Map")) {
          HStack {
            Image(systemName: "wrench.fill")
              .foregroundColor(Color.bikefixPrimary)
            Toggle(isOn: $userSettings.showBicycleRepairStations) {
              Text("Show bike fix stations")
            }
          }

          HStack {
            Image(systemName: "cart.fill")
              .foregroundColor(Color.bikefixPrimary)
            Toggle(isOn: $userSettings.showBicycleShops) {
              Text("Show bike shops")
            }
          }
        }

        Section(header: Text("Extras")) {
          SettingsSafariLink(text: "Website", url: "https://bikefix.app/")
          SettingsSafariLink(text: "Privacy Policy", url: "https://bikefix.app/privacy-policy/")
          feedbackButton
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

  // MARK: - Other views

  var feedbackButton: some View {
    Button(action: {
      let subject = "Flynote Feedback"
      let body = "\n\n\(DeviceInfo.description)"
      guard let coded = "mailto:hello@tapmoko.com?subject=\(subject)&body=\(body)"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

      guard let emailURL = URL(string: coded) else { return }
      if UIApplication.shared.canOpenURL(emailURL) {
        UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
      }
    }) {
      Text("Submit Feedback")
    }
    .accentColor(Color.bikefixPrimary)
  }

}

#if DEBUG
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    SettingsMain()
  }
}
#endif
