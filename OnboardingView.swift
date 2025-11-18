import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var name: String = ""
    @State private var dateOfBirth = Date()
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var gender: Gender = .male
    @State private var activityLevel: ActivityLevel = .sedentary
    @State private var goal: Goal = .maintain
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                }
                
                Section("Lifestyle Choices") {
                    Picker("Sex", selection: $gender) {
                        ForEach(Gender.allCases) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Activity Level", selection: $activityLevel) {
                        ForEach(ActivityLevel.allCases) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                }
                
                Section("Your Goal") {
                    Picker("Goal", selection: $goal) {
                        ForEach(Goal.allCases) { goal in
                            Text(goal.rawValue.capitalized).tag(goal)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("Save Profile & Continue") {
                        calculateAndSave()
                    }
                    .disabled(formIsInvalid)
                }
            }
            .navigationTitle("Create Your Profile")
        }
    }
    
    private var formIsInvalid: Bool {
        name.isEmpty || weight.isEmpty || height.isEmpty
    }
    
    private func calculateAndSave() {
        guard let weightValue = Double(weight),
              let heightValue = Double(height) else {
            return
        }
        
        let userProfile = UserProfile(
            name: name,
            dateOfBirth: dateOfBirth,
            height: heightValue,
            weight: weightValue,
            gender: gender,
            activityLevel: activityLevel,
            goal: goal
        )
        
        let goals = userProfile.calculateGoals()
        
        PersistenceManager.shared.saveUserProfile(userProfile)
        PersistenceManager.shared.saveGoals(goals)
        
        appState.completeOnboarding()
    }
}


