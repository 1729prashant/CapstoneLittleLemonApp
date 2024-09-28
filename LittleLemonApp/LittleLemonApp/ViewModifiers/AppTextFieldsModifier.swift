//
//  AppTextFieldsModifier.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//


import SwiftUI

struct AppTextFieldsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 24)
    }
    
}


struct AppTextFieldsModifierUP: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(12.0)
            .background(Color(.white))
            .cornerRadius(8)
            .frame(maxWidth: 352, alignment: .leading)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.highlightColor2, lineWidth: 1)
            )
    }
}
