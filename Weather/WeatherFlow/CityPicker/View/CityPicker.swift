import SwiftUI

struct CityPicker: View {
    @Binding var currentLocation: LocationModel?
    @State private var currentUserInput = ""
    @StateObject private var viewModel: CityPickerViewModel = Assembly.shared.resolve()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                HStack {
                    Text(city.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    currentLocation = LocationModel(
                        city: city.name,
                        latitude: city.latitude,
                        longitude: city.longitude
                    )
                    dismiss()
                }
            }.searchable(
                text: $currentUserInput,
                prompt: Constants.searchBarHint
            ).onChange(of: currentUserInput) { text in
                if !text.isEmpty {
                    viewModel.searchCityByRequest(text: text)
                } else {
                    viewModel.cities = []
                }
            }
        }
    }
}

private extension CityPicker {
    enum Constants {
        static let searchBarHint = "Поиск города"
    }
}

// swiftlint:disable:next comment_spacing
//struct CityPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPicker()
//    }
//}
// swiftlint:disable:previous comment_spacing
