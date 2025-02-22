//
//  Strings.swift
//  WeatherApp
//
//  Created by Angie Mugo on 21/02/2025.
//

enum AppStrings: String {
    case myLocation = "My Location"
    case fetchingLocation = "Fetching current location..."
    case savedLocations = "Saved Locations"
    case noSavedLocations = "No saved locations yet"
    case trayIcon = "tray.fill"
    case errorTitle = "Error Occurred"
    case genericError = "Generic error"
    case okButton = "OK"
    case highTemperature = "H: %.1f°C"
    case lowTemperature = "L: %.1f°C"
    case currentTemperature = "Current: %.1f°C"
    case personIcon = "person"
    case closeIcon = "x.square"
    case plusIcon = "plus"
    case trashIcon = "trash"
    case delete = "Delete"
    case minTemperature = "Min: %.1f°C"
    case current = "Current"
    case maxTemperature = "Max: %.1f°C"
    case min = "Min"
    case max = "Max"
}

enum LogMessages: String {
    case insertingModels = "Inserting models: "
    case savingContext = "Saving context"
    case errorSavingContext = "Error saving context: "
    case deletingModels = "Deleting models: "
    case checkingAuthorization = "Checking authorization"
    case didUpdateLocations = "Did update locations"
    case updatingLocationsFailed = "Updating locations failed with error "
    case request = "Request: %@ %@"
    case errorEncountered = "Error encountered: %@"

    func formatted(_ args: CVarArg...) -> String {
        return String(format: self.rawValue, arguments: args)
    }
}

enum ErrorMessages: String {
    case locationAccessDenied = "Location access is denied. Please enable it in Settings."
    case decodingTrace = "Decoding response:"
    case errorEncountered = "Error encountered: %@"
    case fetchLocationError = "Failed to fetch current location."
    case decodingError = "Decoding error:: %@"
    case tryAgain = "Reload..."
}
