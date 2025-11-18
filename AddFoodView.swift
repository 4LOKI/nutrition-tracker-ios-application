import SwiftUI

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var foodDataManager: FoodDataManager
    
    @State private var name = ""
    @State private var servingSize = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fat = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Food Details")) {
                    TextField("Food Name", text: $name)
                    TextField("Serving Size (e.g., 100g)", text: $servingSize)
                }
                
                Section(header: Text("Macronutrients")) {
                    TextField("Calories (kcal)", text: $calories)
                        .keyboardType(.numberPad)
                    TextField("Protein (g)", text: $protein)
                        .keyboardType(.decimalPad)
                    TextField("Carbs (g)", text: $carbs)
                        .keyboardType(.decimalPad)
                    TextField("Fat (g)", text: $fat)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Button("Save Food") {
                        saveFood()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(formIsInvalid)
                }
            }
            .navigationTitle("Add Custom Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var formIsInvalid: Bool {
        name.isEmpty || servingSize.isEmpty || calories.isEmpty || protein.isEmpty || carbs.isEmpty || fat.isEmpty
    }
    
    private func saveFood() {
        guard let caloriesInt = Int(calories),
              let proteinDouble = Double(protein),
              let carbsDouble = Double(carbs),
              let fatDouble = Double(fat) else {
            // Data is not in the correct format
            return
        }
        
        let newFood = FoodItem(
            id: UUID().uuidString, // Custom foods get a new unique ID
            name: name,
            servingSize: servingSize,
            calories: caloriesInt,
            protein: proteinDouble,
            carbs: carbsDouble,
            fat: fatDouble
        )
        
        foodDataManager.addCustomFood(newFood)
    }
}

