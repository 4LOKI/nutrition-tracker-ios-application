import Foundation
import Combine

class FoodDataManager: ObservableObject {
    @Published private(set) var allFoods: [FoodItem] = []
    
    private var defaultFoods: [FoodItem] = []
    private var customFoods: [FoodItem] = []

    init() {
        loadDefaultFoods()
        loadCustomFoods()
        updateAllFoods()
    }
    
    private func loadDefaultFoods() {
        guard let url = Bundle.main.url(forResource: "foods", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let loadedFoods = try? JSONDecoder().decode([FoodItem].self, from: data) else {
            fatalError("Failed to load or decode foods.json")
        }
        self.defaultFoods = loadedFoods
    }

    private func loadCustomFoods() {
        self.customFoods = PersistenceManager.shared.loadCustomFoods()
        updateAllFoods()
    }

    private func updateAllFoods() {
        allFoods = (defaultFoods + customFoods).sorted { $0.name < $1.name }
    }
    
    func addCustomFood(_ food: FoodItem) {
        customFoods.append(food)
        PersistenceManager.shared.saveCustomFoods(customFoods)
        updateAllFoods()
    }
}

