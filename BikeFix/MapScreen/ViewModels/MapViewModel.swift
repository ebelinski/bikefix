import Combine

class MapViewModel: ObservableObject {

    var nodeProvider: NodeProvider

    init(nodeProvider: NodeProvider) {
        self.nodeProvider = nodeProvider
    }

}
