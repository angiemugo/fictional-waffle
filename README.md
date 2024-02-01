# Weather App 
Weather app is a small app that uses the [open weather api](https://openweathermap.org/api) to fetch current weather data and forecast weather data. 

## Sample Screenshots 
<img src="https://github.com/angiemugo/fictional-waffle/assets/23118371/dd7a752a-7703-49f4-a6c4-4bccace8b05a" width="200" height="400" alt="Pokemons List">
<img src="https://github.com/angiemugo/fictional-waffle/assets/23118371/6601e6f8-6c3d-4312-8073-44dda34ca0df" width="200" height="400" alt="Pokemons List">
<img src="https://github.com/angiemugo/fictional-waffle/assets/23118371/cd8bfed2-dcfc-4225-a018-08bf5750720f" width="200" height="400" alt="Pokemons List">
<img src="https://github.com/angiemugo/fictional-waffle/assets/23118371/98570c36-e530-4c91-bfc8-8aeb33db3b98" width="200" height="400" alt="Pokemons List">

## Prerequisites
These are the tools we need to run the project 
- Xcode 15.0 or newer 
- iOS 16 or newer

## Installation
`$ git clone https://github.com/angiemugo/fictional-waffle.git`

## Getting started 
1. Open the Xcode project in Xcode.
2. Build and run the project.
3. Explore the app on an iOS device so that you have access to the location services..

## Project Structure 

WeatherApp/
│
├─ WeatherApp/
│   ├── View/
│   ├── Network/
│   ├── Extensions/

├─ WeatherAppTests/

## Technologies Used
 **Programming Language:** Swift 6
 **Development Environment:** Xcode 15.0
 **Version Control:** Git
 **UI Framework:** SwiftUI
 **Database:** Swift Data 
 **Networking:** URLSession 
 **Testing Framework:** XCTest

## Technology
### Architecture 
- I used a flavor of mvvm. Since SwiftUI already implements a lot of reactivity, writing View Models for every view can be counterproductive. I therefore stuck to bareboned models and did most of the work in the views.

### Concurrency
- I used Async await as opposed to the commonly used completion handlers. Async await handles error handling very elegantly. I used a main actor for the view models since it runs on the main loop(which is typically used to update the view)

### CI/CD
- I implemented faslane and added two lanes
-  ONe generates code coverage and the other runs tests
 

## App Features 
* Show a list of all saved locations and the weather at the current location 
* Once you tap on a location you view the current weather and the weather forecast of the location]
* while viewing a location detail, tap on the favorite button to toggle it 
* Save a location after tapping on it on the map 


