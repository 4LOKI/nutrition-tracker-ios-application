import Foundation
import SwiftUI
import Combine

class ChartDataManager: ObservableObject {
    @Published var historicalLogs: [DailyLog] = []
    @Published var selectedTimeRange: TimeRange = .week
    
    let chartType: ChartType
    private var cancellables = Set<AnyCancellable>()
    
    init(chartType: ChartType) {
        self.chartType = chartType
        
        $selectedTimeRange
            .sink { [weak self] _ in
                self?.loadData()
            }
            .store(in: &cancellables)
        
        loadData()
    }
    
    func loadData() {
        let days = selectedTimeRange.days
        self.historicalLogs = PersistenceManager.shared.loadAllLogs(forLast: days)
    }
    
    func saveData(date: Date, value: String) {
        guard let doubleValue = Double(value) else { return }
        
        let targetDate = date.startOfDay
        var dailyLog = PersistenceManager.shared.loadLog(for: targetDate)
        
        if chartType == .water {
            dailyLog.waterIntake = Int(doubleValue)
        } else {
            let manualFoodItem = createManualFoodItem(value: doubleValue)
            let loggedItem = LoggedFoodItem(food: manualFoodItem, dateAdded: Date(), meal: .snacks)
            dailyLog.loggedFoods.append(loggedItem)
        }
        
        PersistenceManager.shared.saveLog(dailyLog)
        
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    func yValue(for log: DailyLog) -> Double {
        switch chartType {
        case .calories: return log.totalCalories
        case .protein: return log.totalProtein
        case .carbs: return log.totalCarbs
        case .fat: return log.totalFat
        case .water: return Double(log.waterIntake)
        }
    }
    
    private func createManualFoodItem(value: Double) -> FoodItem {
        let name = "Manual Entry - \(chartType.rawValue.capitalized)"
        var calories: Int = 0
        var protein: Double = 0
        var carbs: Double = 0
        var fat: Double = 0
        
        switch chartType {
        case .calories:
            calories = Int(value)
        case .protein:
            protein = value
        case .carbs:
            carbs = value
        case .fat:
            fat = value
        case .water:
            break
        }
        
        return FoodItem(id: UUID().uuidString, name: name, servingSize: "Manual", calories: calories, protein: protein, carbs: carbs, fat: fat)
    }
}

