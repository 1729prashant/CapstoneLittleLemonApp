//
//  iOSCheckboxToggleStyle.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 28/09/24.
//

import SwiftUI


struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1 We use a button as a body of our new style.
        Button(action: {

            // 2 When the button is tapped, we toggle the isOn configuration variable, configuration.isOn.toggle().
            configuration.isOn.toggle()

        }, label: {
            HStack {
                // 3 We use an SF Symbol image to represent the selected and unselected state of the checkbox.
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.primaryColor1)

                configuration.label
            }
        })
    }
}
