import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let profile: UserProfile
    
    @State private var name: String
    @State private var dateOfBirth: Date
    @State private var weight: String
    @State private var height: String
    @State private var gender: Gender
    @State private var activityLevel: ActivityLevel
    @State private var goal: Goal
    
    init(profile: UserProfile) {
        self.profile = profile
        _name = State(initialValue: profile.name)
        _dateOfBirth = State(initialValue: profile.dateOfBirth)
        _weight = State(initialValue: String(format: "%.1f", profile.weight))
        _height = State(initialValue: String(format: "%.1f", profile.height))
        _gender = State(initialValue: profile.gender)
        _activityLevel = State(initialValue: profile.activityLevel)
        _goal = State(initialValue: profile.goal)
    }
    
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
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        guard let weightValue = Double(weight),
              let heightValue = Double(height) else {
            return
        }
        
        let updatedProfile = UserProfile(
            name: name,
            dateOfBirth: dateOfBirth,
            height: heightValue,
            weight: weightValue,
            gender: gender,
            activityLevel: activityLevel,
            goal: goal
        )
        
        let updatedGoals = updatedProfile.calculateGoals()
        
        PersistenceManager.shared.saveUserProfile(updatedProfile)
        PersistenceManager.shared.saveGoals(updatedGoals)
    }
}

