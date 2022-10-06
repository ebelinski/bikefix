import SwiftUI

extension Image {
  func mapButtonImageStyle() -> some View {
    self
      .imageScale(.large)
      .frame(minWidth: 50, minHeight: 50)
      .background(Color.mapButtonBackground)
      .cornerRadius(8)
      .shadow(color: Color.shadow, radius: 5)
  }
}
