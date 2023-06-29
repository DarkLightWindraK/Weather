import SwiftUI

struct CityPicker: View {
    @Binding var currentCity: String?
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentUserInput = ""
    @StateObject private var viewModel = CityPickerViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.cities) { city in
                Text(city.name)
                    .onTapGesture {
                        currentCity = city.name
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

//struct CityPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CityPicker()
//    }
//}
