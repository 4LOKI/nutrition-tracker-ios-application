import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    
    @StateObject private var foodDataManager = FoodDataManager()
    @StateObject private var logDataManager = LogDataManager()
    
    var body: some View {
        TabView {
            MainDashboardView()
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
            
            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis")
                }
        }
        .environmentObject(foodDataManager)
        .environmentObject(logDataManager)
    }
}


struct MainDashboardView: View {
    @EnvironmentObject var logDataManager: LogDataManager
    
    @State private var showingAddFoodSheet = false
    
    private var goals: NutritionGoals? {
        return PersistenceManager.shared.loadGoals()
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let goals = goals {
                    Section {
                        NutritionSummaryCard(goals: goals, log: logDataManager.dailyLog)
                    }
                }
                
                Section("Water Intake") {
                    WaterTrackerCard(waterIntake: $logDataManager.dailyLog.waterIntake)
                }

                ForEach(MealType.allCases) { meal in
                    MealSection(meal: meal, log: logDataManager.dailyLog)
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingAddFoodSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAddFoodSheet) {
                AddFoodView()
            }
        }
    }
}

struct NutritionSummaryCard: View {
    let goals: NutritionGoals
    let log: DailyLog
    
    var body: some View {
        VStack {
            ProgressView(value: log.totalCalories, total: goals.calories) {
                Text("Calories")
            } currentValueLabel: {
                Text("\(log.totalCalories, specifier: "%.0f") / \(goals.calories, specifier: "%.0f")")
            }
            .tint(.green)

            HStack {
                VStack {
                    Text("Protein").font(.caption)
                    ProgressView(value: log.totalProtein, total: goals.protein)
                        .tint(.red)
                    Text("\(log.totalProtein, specifier: "%.0f")g / \(goals.protein, specifier: "%.0f")g").font(.caption2)
                }
                VStack {
                    Text("Carbs").font(.caption)
                    ProgressView(value: log.totalCarbs, total: goals.carbs)
                        .tint(.orange)
                     Text("\(log.totalCarbs, specifier: "%.0f")g / \(goals.carbs, specifier: "%.0f")g").font(.caption2)
                }
                VStack {
                    Text("Fat").font(.caption)
                    ProgressView(value: log.totalFat, total: goals.fat)
                        .tint(.blue)
                     Text("\(log.totalFat, specifier: "%.0f")g / \(goals.fat, specifier: "%.0f")g").font(.caption2)
                }
            }
        }
        .padding()
    }
}


struct WaterTrackerCard: View {
    @Binding var waterIntake: Int
    @EnvironmentObject var logDataManager: LogDataManager
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Water Tracker")
                    .font(.headline)
                Text("\(waterIntake) glasses")
                    .font(.title).bold()
            }
            Spacer()
            Button(action: { logDataManager.removeWater() }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: { logDataManager.addWater() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical)
    }
}


struct MealSection: View {
    let meal: MealType
    let log: DailyLog
    @EnvironmentObject var logDataManager: LogDataManager

    private var mealFoods: [LoggedFoodItem] {
        log.loggedFoods.filter { $0.meal == meal }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var body: some View {
        Section(header: Text(meal.rawValue.capitalized)) {
            ForEach(mealFoods) { item in
                HStack {
                    Text(item.food.name)
                    Spacer()
                    Text("\(item.food.calories) kcal")
                        .foregroundColor(.secondary)
                }
            }
            .onDelete { offsets in
                logDataManager.removeFood(at: offsets, from: mealFoods)
            }
            
            NavigationLink(destination: FoodSearchView()) {
                 Text("Add Food")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct FoodSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var foodDataManager: FoodDataManager
    @State private var searchText = ""
    
    private var filteredFoods: [FoodItem] {
        if searchText.isEmpty {
            return foodDataManager.allFoods
        } else {
            return foodDataManager.allFoods.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredFoods) { food in
                NavigationLink(destination: FoodDetailView(food: food)) {
                    Text(food.name)
                }
            }
            .searchable(text: $searchText, prompt: "Search for a food")
            .navigationTitle("Add Food")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

