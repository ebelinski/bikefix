import SwiftUI

struct SettingsMain: View {

  enum IapStatus {
    case nothing, loading, error, success
  }

  // MARK: - Environment

  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  // MARK: - Bindings

  // MARK: - State

  @State var tipButtonText: String?
  @State var iapStatus = IapStatus.nothing

  @AppStorage(SettingsKey.showRepairStations.rawValue)
  var showRepairStations = SettingsDefault.showRepairStations

  @AppStorage(SettingsKey.showShops.rawValue)
  var showShops = SettingsDefault.showShops

  // MARK: - Instance variables

  let feedbackGenerator = UINotificationFeedbackGenerator()
  let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .currency
    return formatter
  }()
  let publisherPurchaseSuccess = NotificationCenter.default.publisher(for: Notification.Name.IAP.purchaseSuccess)
  let publisherPurchaseCancelled = NotificationCenter.default.publisher(for: Notification.Name.IAP.purchaseCancelled)
  let publisherPurchaseFailed = NotificationCenter.default.publisher(for: Notification.Name.IAP.purchaseFailed)

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
      .accentColor(Color.bikefixPrimary)
    }
    .onAppear {
      guard let product = Products.tipProducts.first else { return }
      self.priceFormatter.locale = product.priceLocale
      guard let price = self.priceFormatter.string(from: product.price) else { return }
      self.tipButtonText = "\(price) Tip"
    }
    .onReceive(publisherPurchaseSuccess) { output in
      self.handlePurchaseSuccess(output)
    }
    .onReceive(publisherPurchaseCancelled) { output in
      self.handlePurchaseCancelled()
    }
    .onReceive(publisherPurchaseFailed) { output in
      self.handlePurchaseFailed()
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
        Toggle(isOn: $showRepairStations) {
          Text("Show bike fix stations")
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.bikefixPrimaryOnWhite))
      }

      HStack {
        Image(systemName: "cart.fill")
          .foregroundColor(Color.bikefixPrimary)
        Toggle(isOn: $showShops) {
          Text("Show bike shops")
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.bikefixPrimaryOnWhite))
      }
    }
  }

  var aboutSection: some View {
    Section(header: Text("About")) {
      HStack {
        if iapStatus == .error {
          Text("An unknown error occurred. Please try again later.")
            .foregroundColor(.red)
        } else if iapStatus == .success {
          Text("Thank you so much! 🚴‍♀️💞 Your contribution helps keep BikeFix alive!")
            .foregroundColor(.green)
        } else {
          Text("BikeFix is built by TapMoko, a company by Eugene Belinski.\n\nBikeFix is ad-free, tracker-free, and free of charge! Instead, I rely on your support to fund its development. Please consider leaving a tip in the Tip Jar.")
        }

        tipContainer
      }

      SafariLink(text: "BikeFix Website",
                 url: "https://bikefix.app/")

      SafariLink(text: "Privacy Policy",
                 url: "https://bikefix.app/privacy-policy/")

      feedbackButton
    }
  }

  var tipContainer: some View {
    ZStack {
      if tipButtonText != nil {
        tipButton
      }

      if iapStatus == .loading {
        ProgressView()
      }
    }
    .padding(.horizontal, 5)
    .padding(.top, 10)
    .padding(.bottom, 5)
    .background(Color.softBackground)
    .cornerRadius(10)
  }

  var tipButton: some View {
    Button(action: openTip) {
      VStack {
        Image.init(systemName: "heart.fill")
          .accentColor(.pink)
        Text(tipButtonText ?? "Error Encountered")
      }
    }
    .disabled(iapStatus == .loading)
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
      HStack {
        Image(systemName: "envelope")
        Text("Send Us Feedback!")
        Spacer()
      }
    }
  }

  // MARK: - Methods

  func openTip() {
    guard let product = Products.tipProducts.first else {
      log.error("tipProducts is empty")
      return
    }

    iapStatus = .loading
    Products.store.buyProduct(product)
  }

  func handlePurchaseSuccess(_ notification: Notification) {
    guard let productID = notification.object as? String else {
      log.error("Could not get productID from purchase notification")
      return
    }
    log.info("Got purchase notification for productID \(productID)")

    confirmTipPurchase()
  }

  func handlePurchaseCancelled() {
    iapStatus = .nothing
  }

  func handlePurchaseFailed() {
    iapStatus = .error
  }

  func confirmTipPurchase() {
    iapStatus = .success
  }

}

// MARK: - Preview

#if DEBUG
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingsMain()
        .environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

      SettingsMain()
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
  }
}
#endif
