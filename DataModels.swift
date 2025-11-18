import Foundation
import SwiftUI
import Charts

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

struct FoodItem: Identifiable, Codable, Hashable {
    var id: String
    let name: String
    let servingSize: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
}

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male, female
    var id: String { self.rawValue }
}

enum ActivityLevel: String, CaseIterable, Identifiable, Codable {
    case sedentary, light, moderate, active, veryActive = "very active"
    var id: String { self.rawValue }
}

enum Goal: String, CaseIterable, Identifiable, Codable {
    case lose, maintain, gain
    var id: String { self.rawValue }
}

struct UserProfile: Codable {
    var name: String
    var dateOfBirth: Date
    var height: Double
    var weight: Double
    var gender: Gender
    var activityLevel: ActivityLevel
    var goal: Goal
    
    func calculateGoals() -> NutritionGoals {
        let ageComponents = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date())
        let age = ageComponents.year ?? 0
        
        var bmr: Double
        let weightTerm = 10 * weight
        let heightTerm = 6.25 * height
        let ageTerm = 5 * Double(age)
        
        if gender == .male {
            bmr = weightTerm + heightTerm - ageTerm + 5
        } else {
            bmr = weightTerm + heightTerm - ageTerm - 161
        }
        
        let activityMultiplier: Double
        switch activityLevel {
            case .sedentary: activityMultiplier = 1.2
            case .light: activityMultiplier = 1.375
            case .moderate: activityMultiplier = 1.55
            case .active: activityMultiplier = 1.725
            case .veryActive: activityMultiplier = 1.9
        }
        let tdee = bmr * activityMultiplier
        
        var calorieTarget: Double
        switch goal {
            case .lose: calorieTarget = tdee - 500
            case .maintain: calorieTarget = tdee
            case .gain: calorieTarget = tdee + 500
        }
        
        let protein = weight * 1.8
        let fat = (calorieTarget * 0.25) / 9
        let carbs = (calorieTarget - (protein * 4) - (fat * 9)) / 4
        
        return NutritionGoals(calories: calorieTarget, protein: protein, carbs: carbs, fat: fat)
    }
}

struct NutritionGoals: Codable {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}

enum MealType: String, CaseIterable, Identifiable, Codable {
    case breakfast, lunch, dinner, snacks
    var id: String { self.rawValue }
}

struct LoggedFoodItem: Identifiable, Codable, Hashable {
    var id = UUID()
    let food: FoodItem
    let dateAdded: Date
    let meal: MealType
}

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "W"
    case month = "M"
    var id: String { self.rawValue }

    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        }
    }
}

enum ChartType: String, CaseIterable, Identifiable, Hashable {
    case calories, protein, carbs, fat, water
    var id: String { self.rawValue }
    
    var unit: String {
        switch self {
        case .calories: return "kcal"
        case .protein, .carbs, .fat: return "grams"
        case .water: return "glasses"
        }
    }
    
    var color: Color {
        switch self {
        case .calories: return .green
        case .protein: return .red
        case .carbs: return .orange
        case .fat: return .blue
        case .water: return .teal
        }
    }
}

struct DailyLog: Identifiable, Codable {
    var id: Date { date }
    var date: Date
    var loggedFoods: [LoggedFoodItem]
    var waterIntake: Int = 0

    var totalCalories: Double { loggedFoods.reduce(0) { $0 + Double($1.food.calories) } }
    var totalProtein: Double { loggedFoods.reduce(0) { $0 + $1.food.protein } }
    var totalCarbs: Double { loggedFoods.reduce(0) { $0 + $1.food.carbs } }
    var totalFat: Double { loggedFoods.reduce(0) { $0 + $1.food.fat } }
}


