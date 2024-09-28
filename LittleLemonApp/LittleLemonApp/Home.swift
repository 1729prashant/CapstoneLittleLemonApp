//
//  Home.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//

import SwiftUI


//struct Home: View {
//    let persistence = PersistenceController.shared
//
//    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "kIsLoggedIn")
//    @State private var selectedTab: Int = 0 // Track the current tab
//
//    var body: some View {
//        if isLoggedIn {
//            TabView(selection: $selectedTab) {
//                Menu()
//                    .environment(\.managedObjectContext, persistence.container.viewContext)
//                    .tabItem {
//                        Label("Menu", systemImage: "list.dash")
//                    }
//                    .tag(0) // Tag for Menu tab
//                
//                UserProfile(isLoggedIn: $isLoggedIn, selectedTab: $selectedTab)
//                    .tabItem {
//                        Label("Profile", systemImage: "square.and.pencil")
//                    }
//                    .tag(1) // Tag for Profile tab
//            }
//            .navigationBarBackButtonHidden(true)
//        } else {
//            Onboarding() // If the user isn't logged in
//        }
//    }
//}


struct Home: View {
    let persistence = PersistenceController.shared
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "kIsLoggedIn")

    var body: some View {
        if isLoggedIn {
            Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
                .navigationBarBackButtonHidden(true) // Directly show Menu view after login
        } else {
            Onboarding() // Show Onboarding only when the user isn't logged in
        }
    }
}

#Preview {
    Home()
}
