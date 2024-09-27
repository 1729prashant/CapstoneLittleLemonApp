//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//

import SwiftUI

struct UserProfile: View {
    
    let firstName: String = UserDefaults.standard.string(forKey: "globalFirstName") ?? "Guest"
    let lastName:String = UserDefaults.standard.string(forKey: "globalLastName") ?? ""
    let email:String = UserDefaults.standard.string(forKey: "globalEmail") ?? ""
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Personal information")
            //add image from assets
            Image("profile-image-placeholder")
            Text(firstName)
            Text(lastName)
            Text(email)
            
            
            NavigationLink {
                Onboarding()
            } label: {
                Text("Logout")
            }
            .onTapGesture {
                UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                self.presentation.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    UserProfile()
}
