//
//  Home.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared

    var body: some View {
        TabView {
            
            Tab("Menu", systemImage: "list.dash") {
                Menu()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
            }

            
            Tab("Profile", systemImage: "square.and.pencil") {
                UserProfile()
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
