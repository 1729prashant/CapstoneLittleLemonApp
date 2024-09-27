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
                .font(.title2)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            
            
            
            
            //add image from assets
            Image("profile-image-placeholder")
            Text(firstName)
                
            Text(lastName)
            Text(email)
            
            Spacer()
            NavigationLink {
                Onboarding()
            } label: {
                Text("Log out")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.highlightColor2)
                    .frame(width: 352, height: 44)
                    .background(Color.primaryColor2)
                    .cornerRadius(8)
            }
            .onTapGesture {
                UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                self.presentation.wrappedValue.dismiss()
            }
            
            HStack {
                Button {
                    
                } label: {
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
                .padding(.trailing)
                
                
                Button {
                    
                } label: {
                    Text("Save changes")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 44)
                        .background(Color.primaryColor1)
                        .cornerRadius(8)
                }
                .padding(.leading)
                
            }
        }
    }
}

#Preview {
    UserProfile()
}




