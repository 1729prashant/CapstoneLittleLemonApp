//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//

import SwiftUI

struct UserProfile: View {
    
    let firstName: String = UserDefaults.standard.string(forKey: "globalFirstName") ?? "Firstname"
    let lastName:String = UserDefaults.standard.string(forKey: "globalLastName") ?? "Lastname"
    let email:String = UserDefaults.standard.string(forKey: "globalEmail") ?? "Email"
    let phoneNumber:String = UserDefaults.standard.string(forKey: "globalPhone") ?? ""
    
    
    @Environment(\.presentationMode) var presentation
    
    @State private var orderStatusNotification: Bool = false
    @State private var passwordChangeNotification: Bool = false
    @State private var specialOfferNotification: Bool = false
    @State private var newsletterNotification: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header: Text("Email notifications")
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
                    
                    Section(header: Text("First Name")
                        .font(.subheadline)
                        .bold()
                    ) {
                        Text(firstName)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(12.0)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .frame(maxWidth: 352, alignment: .leading) // Left-align text
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.highlightColor2, lineWidth: 1)
                            )
                    }
                    
                    
                    
                    Section(header: Text("Last Name")
                        .font(.subheadline)
                        .bold()
                    ) {
                        Text(lastName)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(12)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .frame(maxWidth: 352, alignment: .leading) // Left-align text
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.highlightColor2, lineWidth: 1)
                            )
                    }
                    
                    Section(header: Text("Email")
                        .font(.subheadline)
                        .bold()
                    ) {
                        Text(email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(12)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .frame(maxWidth: 352, alignment: .leading) // Left-align text
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.highlightColor2, lineWidth: 1)
                            )
                    }
                    
                    Section(header: Text("Phone number")
                        .font(.subheadline)
                        .bold()
                    ) {
                        Text(phoneNumber)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .padding(12)
                            .background(Color(.white))
                            .cornerRadius(8)
                            .frame(maxWidth: 352, alignment: .leading) // Left-align text
                        
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.highlightColor2, lineWidth: 1)
                            )
                    }
                    
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
                    .padding(.top)
                    
                    HStack(alignment: .center) {
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
                    }
                    .padding()
                    
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline) // Ensures the title is centered
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    // Profile image on the right
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                ToolbarItem(placement: .principal) {
                    // Center icon (you can replace with a custom logo or icon)
                    Image("Logo") // Example system icon
                        .resizable()
                        .frame(width: 180, height: 40)
                    //.foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    // back button on the left
                    Image(systemName:"arrow.left.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.primaryColor1)
                        .onTapGesture {
                            // Trigger back navigation
                            self.presentation.wrappedValue.dismiss()
                        }
                }

            }
        }
    }
}

#Preview {
    UserProfile()
}
