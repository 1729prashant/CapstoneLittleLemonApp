import SwiftUI

struct UserProfile: View {
    
    // State properties for editable fields
    @State private var firstName: String = UserDefaults.standard.string(forKey: "globalFirstName") ?? "Firstname"
    @State private var lastName: String = UserDefaults.standard.string(forKey: "globalLastName") ?? "Lastname"
    @State private var email: String = UserDefaults.standard.string(forKey: "globalEmail") ?? "Email"
    @State private var phoneNumber: String = UserDefaults.standard.string(forKey: "globalPhone") ?? ""
    
    @Environment(\.presentationMode) var presentation
    @Binding var isLoggedIn: Bool
    @Binding var selectedTab: Int // Binding to control the selected tab
    
    @State private var orderStatusNotification: Bool = false
    @State private var passwordChangeNotification: Bool = false
    @State private var specialOfferNotification: Bool = false
    @State private var newsletterNotification: Bool = false
    
    
    @State private var originalFirstName: String = ""
    @State private var originalLastName: String = ""
    @State private var originalEmail: String = ""
    @State private var originalPhoneNumber: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header: Text("Personal information")
                        .font(.title3)
                        .bold()
                    )  {
                        HStack {
                            Image("profile-image-placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                                .padding(.trailing)
                            
                            Button {
                            } label: {
                                Text("Remove")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(width: 100, height: 44)
                                    .background(Color.primaryColor1)
                                    .cornerRadius(8)
                            }
                            
                            Button {
                            } label: {
                                Text("Change")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.highlightColor2)
                                    .frame(width: 100, height: 44)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.primaryColor1, lineWidth: 4)
                                    )
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    // Editable fields
                    Section(header: Text("First Name")
                        .font(.subheadline)
                        .bold()
                    ) {
                        TextField("First Name", text: $firstName)
                            .modifier(AppTextFieldsModifierUP())
                    }
                    
                    Section(header: Text("Last Name")
                        .font(.subheadline)
                        .bold()
                    ) {
                        TextField("Last Name", text: $lastName)
                            .modifier(AppTextFieldsModifierUP())
                    }
                    
                    Section(header: Text("Email")
                        .font(.subheadline)
                        .bold()
                    ) {
                        TextField("Email", text: $email)
                            .modifier(AppTextFieldsModifierUP())
                    }
                    
                    Section(header: Text("Phone number")
                        .font(.subheadline)
                        .bold()
                    ) {
                        TextField("Phone Number", text: $phoneNumber)
                            .modifier(AppTextFieldsModifierUP())
                    }
                    
                    // Email notifications section
                    Section(header: Text("Email notifications")
                        .font(.title3)
                        .bold()
                        .padding(.top)
                    ) {
                        Toggle(isOn: $orderStatusNotification) {
                            Text("Order Statuses")
                                .foregroundStyle(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        
                        Toggle(isOn: $passwordChangeNotification) {
                            Text("Password change")
                                .foregroundStyle(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        
                        Toggle(isOn: $specialOfferNotification) {
                            Text("Special offers")
                                .foregroundStyle(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                        
                        Toggle(isOn: $newsletterNotification) {
                            Text("Newsletter")
                                .foregroundStyle(.black)
                        }
                        .toggleStyle(iOSCheckboxToggleStyle())
                    }
                    .padding(6)
                    
                    HStack {
                        Button(action: {
                            // Clear fields and notifications
                            discardChanges()
                        }) {
                            Text("Discard changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.highlightColor2)
                                .frame(width: 150, height: 44)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primaryColor1, lineWidth: 4)
                                )
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            if isValidInput() {
                                saveChanges()
                            } else {
                                alertMessage = "Please enter at least First Name, Last Name, and Email."
                                showAlert = true
                            }
                        }) {
                            Text("Save changes")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 150, height: 44)
                                .background(Color.primaryColor1)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        // Log out logic
                        UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                        isLoggedIn = false
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.rootViewController = UIHostingController(rootView: Onboarding())
                        }
                    }) {
                        Text("Log out")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.highlightColor2)
                            .frame(width: 352, height: 44)
                            .background(Color.primaryColor2)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 180, height: 40)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        // Check for unsaved changes before navigating back
                        if !hasUnsavedChanges() {
                            presentation.wrappedValue.dismiss() // Dismiss the UserProfile view
                            selectedTab = 0 // Switch back to the Menu tab
                        } else {
                            alertMessage = "You have unsaved changes. Please save them before leaving."
                            showAlert = true
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.primaryColor1)
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Store original values when the view appears
                originalFirstName = firstName
                originalLastName = lastName
                originalEmail = email
                originalPhoneNumber = phoneNumber
            }
        }
        .navigationBarBackButtonHidden(true)

    }

    
    // Method to clear fields and notifications
    private func discardChanges() {
        firstName = ""
        lastName = ""
        email = ""
        phoneNumber = ""
        orderStatusNotification = false
        passwordChangeNotification = false
        specialOfferNotification = false
        newsletterNotification = false
    }
    
    // Method to save changes
    private func saveChanges() {
        UserDefaults.standard.set(firstName, forKey: "globalFirstName")
        UserDefaults.standard.set(lastName, forKey: "globalLastName")
        UserDefaults.standard.set(email, forKey: "globalEmail")
        UserDefaults.standard.set(phoneNumber, forKey: "globalPhone")
        // Save notification preferences if needed
        alertMessage = "Changes saved successfully."
        showAlert = true
        
        // Update the original values after saving
        originalFirstName = firstName
        originalLastName = lastName
        originalEmail = email
        originalPhoneNumber = phoneNumber
    }
    
    // Method to check if input is valid
    private func isValidInput() -> Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty
    }
    
    private func hasUnsavedChanges() -> Bool {
        return firstName != originalFirstName || lastName != originalLastName || email != originalEmail || phoneNumber != originalPhoneNumber
    }
}

#Preview {
    UserProfile(isLoggedIn: .constant(true), selectedTab: .constant(1))
}
