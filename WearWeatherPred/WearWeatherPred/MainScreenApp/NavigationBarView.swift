import SwiftUI

struct BottomBarView: View {
    @Binding var isSettingsPresented: Bool
    @Binding var isShowingWardrobe: Bool
    @State private var isShowingImagePicker = false
    @State private var isShowingImagePickerView = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isShowingClothingForm = false
    @EnvironmentObject var viewModel: WardrobeViewModel
    @State private var detectedTitle: String = ""

    var body: some View {
        ZStack {
            HStack {
                Button(action: {}) {
                    Image(systemName: "cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Button(action: {
                    isShowingWardrobe.toggle()
                }) {
                    Image(systemName: "tshirt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Button(action: {
                    isSettingsPresented.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }

                Spacer()

                Button(action: {
                    isShowingImagePicker = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            .frame(height: 50)
            .background(Color.black.opacity(0.9))
            .clipShape(Capsule())
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .confirmationDialog("Добавить элемент", isPresented: $isShowingImagePicker, titleVisibility: .visible) {
                Button("Сфотографировать") {
                    sourceType = .camera
                    isShowingImagePickerView = true
                }
                Button("Выбрать из галереи") {
                    sourceType = .photoLibrary
                    isShowingImagePickerView = true
                }
                Button("Отмена", role: .cancel) { }
            }
        }
        .fullScreenCover(isPresented: $isShowingImagePickerView) {
            ImagePickerView(sourceType: sourceType) { image in
                if let image = image {
                    selectedImage = image
                    detectedTitle = "Загрузка..." // ✅ Устанавливаем временный текст

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        ImageClassifier.shared.classify(image: image) { result in
                            DispatchQueue.main.async {
                                detectedTitle = result ?? "Unknown"
                                isShowingClothingForm = true // ✅ Анкета открывается после анализа
                            }
                        }
                    }
                } else {
                    isShowingImagePickerView = false // ✅ Закрываем, если фото не выбрано
                }
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { isShowingClothingForm && selectedImage != nil },
            set: { if !$0 { isShowingClothingForm = false; selectedImage = nil } }
        )) {
            if let selectedImage = selectedImage {
                ClothingFormView(item: .constant(ClothingItem(image: selectedImage, title: detectedTitle, category: .item, season: "Hot", type: "Daily")))
                    .environmentObject(viewModel)
            } else {
                Text("Не удалось загрузить изображение") // ✅ Теперь корректное сообщение об ошибке
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
}
