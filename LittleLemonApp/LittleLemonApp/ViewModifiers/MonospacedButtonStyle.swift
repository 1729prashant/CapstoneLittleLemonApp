//
//  MonospacedButtonStyle.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 28/09/24.
//

import SwiftUI

struct MonospacedButtonStyle: ButtonStyle {
    var isSelected: Bool // Tracks if the button is selected

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? Color.lightGreen : Color.primaryColor1) // Change text color if selected
            .frame(width: 80, height: 40)
            .background(isSelected ? Color.primaryColor1 : Color.lightGreen, in: Capsule()) // Invert background if selected
            .font(Font.custom("Karla-bold", size: 18))
    }
}
