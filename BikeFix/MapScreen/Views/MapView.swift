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
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        // Setting it right away doesn't work, due to some funny behavior with
        // MapView's mapViewDidChangeVisibleRegion method.
        self.viewModel.shouldNavigateToUserLocation = true
      }
    }
  }

  // MARK: - Other views

  var map: some View {
    MapViewRepresentable(
      nodeProvider: viewModel.nodeProvider,
      nodes: $viewModel.nodeProvider.nodes,
      openedNodeVM: $viewModel.openedNodeVM,
      displayingLocationAuthRequest: $viewModel.displayingLocationAuthRequest,
      shouldNavigateToUserLocation: $viewModel.shouldNavigateToUserLocation
    )
    .accentColor(Color.bikefixPrimaryOnWhite)
    .edgesIgnoringSafeArea(.all)
  }

  var mapOverlays: some View {
    VStack {
      if viewModel.displayFirstTimeMessage {
        FirstTimeView() {
          withAnimation {
            viewModel.displayFirstTimeMessage = false
          }
        }
        .transition(.opacity)
      }

      Spacer()

      HStack {
        Spacer()

        VStack {
          Spacer()
          if viewModel.nodeProvider.loading {
            loadingIndicator
          }
          settingsButton
          locationButton
        }
        .padding(10)
      }
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

  var locationButton: some View {
    Button(action: viewModel.checkForLocationAuthorizationAndNavigateToUserLocation) {
      Image(systemName: "location")
        .mapButtonImageStyle()
        .accessibility(label: Text("Locate Me"))
    }
    .padding(5)
    .hoverEffect()
  }
  
}

struct Map_Previews: PreviewProvider {
  static var previews: some View {
      MapView(viewModel: MapViewModel(nodeProvider: NodeProvider()))
        .preferredColorScheme(.light)

      MapView(viewModel: MapViewModel(nodeProvider: NodeProvider()))
        .preferredColorScheme(.dark)
  }
}
