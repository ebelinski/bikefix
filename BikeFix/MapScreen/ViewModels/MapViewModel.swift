import Combine

class MapViewModel: ObservableObject {

    @Published var showingSettings = false
    @Published var displayingLocationAuthRequest = false
    @Published var shouldNavigateToUserLocation = false
    @Published var openedNodeVM: NodeViewModel? = nil

    var nodeProvider: NodeProvider

    init(nodeProvider: NodeProvider) {
        self.nodeProvider = nodeProvider
    }

}
