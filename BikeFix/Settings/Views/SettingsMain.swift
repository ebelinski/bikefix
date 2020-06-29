import SwiftUI

struct SettingsMain: View {

  // MARK: - Environment

  @EnvironmentObject var userSettings: UserSettings

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Bindings

  // MARK: - State

  // MARK: - Instance variables

  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()

  // MARK: - Body view

  var body: some View {
    NavigationView {
      Form {
        mapSettingsSection

        aboutSection

        sourceCodeSection
      }
      .buttonStyle(BorderlessButtonStyle()) // Required to prevent the first button in a list being the only functional button.
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

  var mapSettingsSection: some View {
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
  }

  var aboutSection: some View {
    Section(header: Text("About")) {
      HStack {
        Text("BikeFix is built by TapMoko, a company by Eugene Belinski.\n\nBikeFix is ad-free, tracker-free, and free of charge! Instead, I rely on your support to fund its development. Please consider leaving a tip in the Tip Jar.")

        Button(action: {}) {
          VStack {
            Image.init(systemName: "heart.fill")
              .accentColor(.pink)
            Text("$1.99 Tip")
          }
        }
        .padding(.horizontal, 5)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .accentColor(Color.bikefixPrimary)
        .background(Color.softBackground)
        .cornerRadius(10)
      }

      SafariLink(text: "BikeFix Website",
                 url: "https://bikefix.app/")

      SafariLink(text: "Privacy Policy",
                 url: "https://bikefix.app/privacy-policy/")

      feedbackButton
    }
  }

  var sourceCodeSection: some View {
    Section(header: Text("Source Code")) {
      Text("BikeFix is open source! It is written in Swift 5, and released under the GNU-GPL 3.0 license.")

      SafariLink(text: "View Source",
                 url: "https://github.com/ebelinski/bikefix")
    }
  }

  var feedbackButton: some View {
    Button(action: {
      let subject = "BikeFix Feedback"
      let body = "\n\n\(DeviceInfo.description)"
      guard let coded = "mailto:hello@tapmoko.com?subject=\(subject)&body=\(body)"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

      guard let emailURL = URL(string: coded) else { return }
      if UIApplication.shared.canOpenURL(emailURL) {
        UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
      }
    }) {
      Text("Send Us Feedback!")
    }
    .accentColor(Color.bikefixPrimary)
  }

  // MARK: - Methods

}

// MARK: - Preview

#if DEBUG
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingsMain()
        .environmentObject(UserSettings())
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

      SettingsMain()
        .environmentObject(UserSettings())
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
  }
}
#endif
