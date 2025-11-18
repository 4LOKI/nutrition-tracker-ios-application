import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingResetAlert = false
    
    private var userProfile: UserProfile? {
        return PersistenceManager.shared.loadUserProfile()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                if let profile = userProfile {
                    Section("Personal Information") {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(profile.name).foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Date of Birth")
                            Spacer()
                            Text(dateFormatter.string(from: profile.dateOfBirth)).foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Sex")
                            Spacer()
                            Text(profile.gender.rawValue.capitalized).foregroundColor(.secondary)
                        }
                    }
                    
                    Section("Body Measurements") {
                        HStack {
                            Text("Weight")
                            Spacer()
                            Text("\(profile.weight, specifier: "%.1f") kg").foregroundColor(.secondary)
                        }
                         HStack {
                            Text("Height")
                            Spacer()
                            Text("\(profile.height, specifier: "%.1f") cm").foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("No profile information found.")
                }
                
                Section("Account Actions") {
                    Button("Reset App") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let profile = userProfile {
                        NavigationLink("Edit", destination: EditProfileView(profile: profile))
                    }
                }
            }
            .alert("Reset App?", isPresented: $showingResetAlert) {
                Button("Reset", role: .destructive) {
                    PersistenceManager.shared.deleteAllData()
                    appState.resetOnboarding()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
        }
    }
}


