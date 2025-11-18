import Foundation
import SwiftUI
import Combine

class LogDataManager: ObservableObject {
    @Published var dailyLog: DailyLog
    
    init() {
        self.dailyLog = PersistenceManager.shared.loadLog(for: Date())
    }
    
    private func saveLog() {
        PersistenceManager.shared.saveLog(dailyLog)
    }

    func addFood(_ food: FoodItem, meal: MealType) {
        let loggedItem = LoggedFoodItem(food: food, dateAdded: Date(), meal: meal)
        dailyLog.loggedFoods.append(loggedItem)
        saveLog()
    }
    
    func removeFood(at offsets: IndexSet, from mealFoods: [LoggedFoodItem]) {
        guard !mealFoods.isEmpty else { return }
        
        let idsToRemove = offsets.map { mealFoods[$0].id }
        dailyLog.loggedFoods.removeAll { idsToRemove.contains($0.id) }
        saveLog()
    }
    
    func addWater() {
        dailyLog.waterIntake += 1
        saveLog()
    }
    
    func removeWater() {
        if dailyLog.waterIntake > 0 {
            dailyLog.waterIntake -= 1
            saveLog()
        }
    }
}

