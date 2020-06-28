import SwiftUI

struct CopyButton: View {

  // MARK: - Instance variables

  private let feedbackGenerator = UINotificationFeedbackGenerator()
  let text: String

  // MARK: - State

  @State var showingSuccessConfirmation = false

  // MARK: - Body view

  var body: some View {
    HStack {
      if showingSuccessConfirmation {
        Image(systemName: "checkmark")
      } else {
        Button(action: copyText) {
          Image(systemName: "doc.on.doc")
            .foregroundColor(Color.bikefixPrimary)
        }
      }
    }
  }

  // MARK: - Private methods

  private func copyText() {
    UIPasteboard.general.string = text
    feedbackGenerator.notificationOccurred(.success)

    showingSuccessConfirmation = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.showingSuccessConfirmation = false
    }
  }

}
