import SwiftUI

struct FirstTimeView: View {
  let closeAction: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      Text("**Welcome to BikeFix!** To see bicycle repair stations and stores, press the \(Image(systemName: "location")) button at the bottom-right, or pinch to zoom.")

      Button(action: closeAction) {
        Image(systemName: "xmark.circle.fill")
      }
      .tint(.primary)
    }
    .padding(10)
    .background(.ultraThinMaterial)
    .cornerRadius(8)
    .padding(10)
  }
}

struct FirstTimeView_Previews: PreviewProvider {
  static var previews: some View {
    FirstTimeView() {}
  }
}
