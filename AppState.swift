import Foundation
import Combine

class AppState: ObservableObject {
    @Published var hasOnboarded: Bool

    init() {
        self.hasOnboarded = PersistenceManager.shared.loadGoals() != nil
    }
    
    func completeOnboarding() {
        self.hasOnboarded = true
    }
    
    func resetOnboarding() {
        self.hasOnboarded = false
    }
}


