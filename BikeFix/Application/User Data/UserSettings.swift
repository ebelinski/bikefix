import Foundation
import Combine
import UIKit

// Settings are saved to User Defaults when the user makes a change. If the user doesn't make a change, nothing is saved in User Defaults, and the Default is used.

class UserSettings: ObservableObject {

  enum BoolSettingsKey: String, CaseIterable {
    case didLaunchOnce
    case showBicycleRepairStations
    case showBicycleShops
  }

  struct Default {
    static let showBicycleRepairStations = true
    static let showBicycleShops = true
  }

  @Published var showBicycleRepairStations: Bool = Default.showBicycleRepairStations {
    didSet { set(bool: showBicycleRepairStations, for: .showBicycleRepairStations) }
  }

  @Published var showBicycleShops: Bool = Default.showBicycleShops {
    didSet { set(bool: showBicycleShops, for: .showBicycleShops) }
  }

  init() {
    if !storedBool(for: .didLaunchOnce) {
      initializeUserDefaultValues()
      set(bool: true, for: .didLaunchOnce)
    }

    setFromUserDefaults()
  }

  private func initializeUserDefaultValues() {
    set(bool: Default.showBicycleRepairStations, for: .showBicycleRepairStations)
    set(bool: Default.showBicycleShops, for: .showBicycleShops)
  }

  private func setFromUserDefaults() {
    showBicycleRepairStations = storedBool(for: .showBicycleRepairStations)
    showBicycleShops = storedBool(for: .showBicycleShops)
  }

  private func set(bool: Bool, for settingsKey: BoolSettingsKey) {
    UserDefaults.standard.set(bool, forKey: settingsKey.rawValue)
  }

  private func storedBool(for settingsKey: BoolSettingsKey) -> Bool {
    return UserDefaults.standard.bool(forKey: settingsKey.rawValue)
  }

}
