//
//  FieldPicker.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 03.05.2025.
//
import SwiftUI

struct FieldPicker<T: RawRepresentable & CaseIterable>: View where T.RawValue == String {
    let label: String
    let options: [String]
    @Binding var selection: T?
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label):").bold()
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { opt in
                    Button(opt.capitalized) { selection = T(rawValue: opt) }
                        .padding(.vertical, 8).frame(maxWidth: .infinity)
                        .background(selection?.rawValue == opt ? Color("CardAccent") : Color.white)
                        .foregroundColor(selection?.rawValue == opt ? .white : .black)
                        .cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3)))
                }
            }
        }
    }
}
