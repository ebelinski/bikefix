import SwiftUI
import MapKit

struct MapView: View {

  // MARK: - Observables

  @ObservedObject var viewModel: MapViewModel

  // MARK: - Instance variables

  private let mapButtonDimension: CGFloat = 50

  // MARK: - Body view

  var body: some View {
    ZStack {
      map
        .sheet(
          item: $viewModel.openedNodeVM,
          onDismiss: viewModel.onNodeDetailDismiss
        ) { nodeVM in
          NodeDetails(nodeVM: nodeVM)
            .navigationViewStyle(StackNavigationViewStyle())
        }

      mapOverlays
    }
    .onAppear {
      viewModel.moveToUserLocation()
    }
  }

  // MARK: - Other views

  var map: some View {
    Map(
      coordinateRegion: $viewModel.mapRegion,
      interactionModes: .all,
      showsUserLocation: true
    )
    .accentColor(Color.bikefixPrimaryOnWhite)
    .edgesIgnoringSafeArea(.all)
  }

  var mapOverlays: some View {
    HStack {
      Spacer()

      VStack {
        Spacer()
        if viewModel.nodeProvider.loading {
          loadingIndicator
        }
        settingsButton
        locateMeButton
      }
      .padding(10)
    }
    .padding(.bottom, 20)
  }

  var loadingIndicator: some View {
    ProgressView()
      .accessibility(label: Text("Loading map data..."))
      .frame(minWidth: mapButtonDimension, minHeight: mapButtonDimension)
      .background(Color.mapButtonBackground)
      .cornerRadius(8)
      .shadow(color: Color.shadow, radius: 5)
      .padding(5)
  }

  var settingsButton: some View {
    Button(action: { self.viewModel.showingSettings.toggle() }) {
      Image(systemName: "gear")
        .mapButtonImageStyle()
        .accessibility(label: Text("Settings"))
    }
    .padding(5)
    .hoverEffect()
    .sheet(isPresented: $viewModel.showingSettings) {
      SettingsMain()
        .navigationViewStyle(StackNavigationViewStyle())
    }
  }

  var locateMeButton: some View {
    Button(action: viewModel.checkForLocationAuthorizationAndNavigateToUserLocation) {
      Image(systemName: "location")
        .mapButtonImageStyle()
        .accessibility(label: Text("Locate Me"))
    }
    .padding(5)
    .hoverEffect()
  }
  
}

#if DEBUG
struct Map_Previews: PreviewProvider {
  static var previews: some View {
    MapView(viewModel: MapViewModel(nodeProvider: NodeProvider()))
  }
}
#endif
