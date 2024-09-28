//
//  Onboarding.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//

import SwiftUI


//global vars as per instructions only, refactor for security
public var globalFirstName: String = ""
public var globalLastName: String = ""
public var globalEmail: String = ""
public var globalPhone: String = ""



struct Onboarding: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""

    
    @State private var showAlert: Bool = false
    //@State private var alertMessage: String = ""
    
    private let kIsLoggedIn = "kIsLoggedIn"

    // Function to validate email using regex
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    var isFormValid: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                TextField("First Name",text: $firstName)
                    .modifier(AppTextFieldsModifier())
                
                
                TextField("Last Name",text: $lastName)
                    .modifier(AppTextFieldsModifier())
                
                
                TextField("Email",text: $email)
                    .modifier(AppTextFieldsModifier())
                
                
                NavigationLink {
                    Home()
                } label: {
                    Text("Register")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 352, height: 44)
                        .background(isFormValid ? Color.black : Color.gray) // Gray out the button if form is invalid
                        .cornerRadius(8)
                }
                .disabled(!isFormValid) // Disable the button if form is invalid
                .onChange(of: isFormValid) {
                    // Save to UserDefaults when the form is valid
                    globalFirstName = firstName
                    globalLastName = lastName
                    globalEmail = email
                    UserDefaults.standard.set(firstName, forKey: "globalFirstName")
                    UserDefaults.standard.set(lastName, forKey: "globalLastName")
                    UserDefaults.standard.set(email, forKey: "globalEmail")
                    UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                    UserDefaults.standard.set(email, forKey: "globalPhone")
                }
                
                
            } // VStack
            .onAppear {
                // Check if the user is already logged in
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    // If logged in, navigate directly to Home
                    NavigationLink(destination: Home()) {
                        EmptyView()
                    }.hidden()
                }
            }
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Onboarding()
}
