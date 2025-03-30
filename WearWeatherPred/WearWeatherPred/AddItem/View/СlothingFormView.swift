//
//  СlothingFormView.swift
//  WearWeatherPred
//
//  Created by Наталья Захарова on 16.03.2025.
//
import SwiftUI

struct ClothingFormView: View {
    @Binding var item: ClothingItem
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: WardrobeViewModel

    var body: some View {
        VStack {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            VStack(spacing: 10) {
                HStack {
                    Text("Name:").bold()
                    TextField("Enter name", text: $item.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading) {
                    Text("Category:").bold()
                    HStack {
                        Button("accessories") { item.category = .accessories }
                        Button("item") { item.category = .item }
                        Button("shoes") { item.category = .shoes }
                    }
                    
                    Text("Season:").bold()
                    HStack {
                        Button("hot") { item.season = .hot }
                        Button("cold") { item.season = .cold }
                        Button("rainy") { item.season = .rainy }
                    }
                    Text("Type:").bold()
                    HStack {
                        Button("daily") { item.type = .daily }
                        Button("casual") { item.type = .casual }
                        Button("party") { item.type = .party }
                    }
                }

                Button(action: {
                    viewModel.addItem(item)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
