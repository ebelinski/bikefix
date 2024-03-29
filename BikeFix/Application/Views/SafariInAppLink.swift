import SwiftUI

struct SafariInAppLink: View {

  let text: String
  let url: String

  var body: some View {
    NavigationLink(destination: SafariView(url: URL(string: url)!)) {
      Text(text)
    }
  }

}
