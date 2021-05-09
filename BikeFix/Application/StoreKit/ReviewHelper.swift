import StoreKit
import SwiftUI

struct ReviewHelper {

  static let shared = ReviewHelper()

  // MARK: - Private properties

  @AppStorage("ReviewHelper.allTimeReviewRequestCount") var allTimeReviewRequestCount = 0
  @AppStorage("ReviewHelper.allTimeAppOpenCount") var allTimeAppOpenCount = 0
  @AppStorage("ReviewHelper.allTimeNodeDetailDismissCount") var allTimeNodeDetailDismissCount = 0

  private var currentScene: UIWindowScene? {
    let scenes = UIApplication.shared.connectedScenes
    return scenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
  }

  // MARK: - Public methods

  func requestReviewIfAppropriate() {
    log.info("requestReviewIfAppropriate starting...")
    log.info("allTimeReviewRequestCount: \(allTimeReviewRequestCount)")
    log.info("allTimeAppOpenCount: \(allTimeAppOpenCount)")
    log.info("allTimeNodeDetailDismissCount: \(allTimeNodeDetailDismissCount)")

    // Don't request a review if we already did it
    if allTimeReviewRequestCount > 0 {
      log.info("requestReviewIfAppropriate: Not requesting due to allTimeReviewRequestCount > 0")
      return
    }

    // Only request if this is the third or later app open
    if allTimeAppOpenCount < 3 {
      log.info("requestReviewIfAppropriate: Not requesting due to allTimeAppOpenCount < 3")
      return
    }

    // Only request if this is the third dismissal or later
    if allTimeNodeDetailDismissCount < 3 {
      log.info("requestReviewIfAppropriate: Not requesting due to allTimeNodeDetailDismissCount < 3")
      return
    }

    guard let scene = currentScene else {
      log.error("requestReviewIfAppropriate: Not requesting due to currentScene == nil")
      return
    }

    SKStoreReviewController.requestReview(in: scene)
    allTimeReviewRequestCount += 1
  }

}
