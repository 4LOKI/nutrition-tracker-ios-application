import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}

    private let goalsKey = "userGoals"
    private let profileKey = "userProfile"
    private let logKeyPrefix = "userLog_"
    private let customFoodsKey = "customFoods"
    
    private func logKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "\(logKeyPrefix)\(formatter.string(from: date.startOfDay))"
    }

    func saveGoals(_ goals: NutritionGoals) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }

    func loadGoals() -> NutritionGoals? {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode(NutritionGoals.self, from: data) {
            return decoded
        }
        return nil
    }

    func saveUserProfile(_ profile: UserProfile) {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    func loadUserProfile() -> UserProfile? {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return decoded
        }
        return nil
    }

    func saveLog(_ log: DailyLog) {
        if let encoded = try? JSONEncoder().encode(log) {
            UserDefaults.standard.set(encoded, forKey: logKey(for: log.date))
        }
    }

    func loadLog(for date: Date) -> DailyLog {
        if let data = UserDefaults.standard.data(forKey: logKey(for: date)),
           let decoded = try? JSONDecoder().decode(DailyLog.self, from: data) {
            return decoded
        }
        return DailyLog(date: date.startOfDay, loggedFoods: [])
    }
    
    func loadAllLogs(forLast days: Int) -> [DailyLog] {
        var logs: [DailyLog] = []
        for i in 0..<days {
            if let targetDate = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                logs.append(loadLog(for: targetDate))
            }
        }
        return logs.sorted { $0.date < $1.date }
    }
    
    func saveCustomFoods(_ foods: [FoodItem]) {
        if let encoded = try? JSONEncoder().encode(foods) {
            UserDefaults.standard.set(encoded, forKey: customFoodsKey)
        }
    }
    
    func loadCustomFoods() -> [FoodItem] {
        if let data = UserDefaults.standard.data(forKey: customFoodsKey),
           let decoded = try? JSONDecoder().decode([FoodItem].self, from: data) {
            return decoded
        }
        return []
    }

    func deleteAllData() {
        UserDefaults.standard.removeObject(forKey: goalsKey)
        UserDefaults.standard.removeObject(forKey: profileKey)
        UserDefaults.standard.removeObject(forKey: customFoodsKey)
        
        for i in 0..<365 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                UserDefaults.standard.removeObject(forKey: logKey(for: date))
            }
        }
    }
}


