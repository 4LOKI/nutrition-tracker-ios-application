import SwiftUI

struct FoodDetailView: View {
    let food: FoodItem
    @EnvironmentObject var logDataManager: LogDataManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedMeal: MealType = .snacks
    
    var body: some View {
        Form {
            Section("Nutrition Facts (per \(food.servingSize))") {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text("\(food.calories)")
                }
                HStack {
                    Text("Protein")
                    Spacer()
                    Text("\(food.protein, specifier: "%.1f")g")
                }
                HStack {
                    Text("Carbohydrates")
                    Spacer()
                    Text("\(food.carbs, specifier: "%.1f")g")
                }
                HStack {
                    Text("Fat")
                    Spacer()
                    Text("\(food.fat, specifier: "%.1f")g")
                }
            }
            
            Section("Log to Meal") {
                Picker("Meal", selection: $selectedMeal) {
                    ForEach(MealType.allCases) { meal in
                        Text(meal.rawValue.capitalized).tag(meal)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Button("Add to Log") {
                    logDataManager.addFood(food, meal: selectedMeal)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle(food.name)
    }
}

