import SwiftUI

struct CityPicker: View {
    @Binding var currentLocation: LocationModel?
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentUserInput = ""
    @StateObject private var viewModel: CityPickerViewModel = Assembly.shared.resolve()
    
    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                Text(city.name)
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
                prompt: "Поиск города"
            ).onChange(of: currentUserInput) { newValue in
                viewModel.searchCityByRequest(text: newValue)
            }
        }
    }
}

// swiftlint:disable:next comment_spacing
//struct CityPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPicker()
//    }
//}
// swiftlint:disable:previous comment_spacing
