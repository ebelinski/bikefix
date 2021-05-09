import SwiftUI

struct SimpleDetailCell: View {

  let title: String
  let content: String

  var body: some View {
    HStack {
      Text("\(title): ").fontWeight(.bold) + Text(content)
      Spacer()
      CopyButton(text: content)
    }
  }

}
