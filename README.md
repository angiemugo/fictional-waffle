# Weather App 
Weather app is a small app that uses the [open weather api](https://openweathermap.org/api) to fetch current weather data and forecast weather data. 

## Sample Screenshots 

![IMG_0969](https://github.com/user-attachments/assets/606dab37-1ff6-4a2f-81a3-18e7ebff41b1)
![IMG_0968](https://github.com/user-attachments/assets/4bfd20b6-9f72-42a6-af12-b5e66a2f87cf)
![IMG_0967](https://github.com/user-attachments/assets/b8bcd863-8fc9-4d62-87d5-e4fbcbc99087)
![IMG_0966](https://github.com/user-attachments/assets/2011244a-21b4-415d-b7f0-0f2b629363c3)

## Prerequisites
These are the tools we need to run the project 
- Xcode 16.2 or newer 
- iOS 18.0  or newer

## Installation
`$ git clone https://github.com/angiemugo/fictional-waffle.git`

## Getting started 
1. Open the Xcode project in Xcode.
2. Build and run the project.
3. Explore the app on an iOS device so that you have access to the location services.
4. The iOS simulator gives a default location so it's recommended to use your physical device

## Project Structure 

WeatherApp/
│
├─ WeatherApp/
|   |-- Utils/
│   ├── View/
│   ├── Network/
│   ├── Extensions/

├─ WeatherAppTests/

## Technologies Used
 **Programming Language:** Swift 
 **Development Environment:** Xcode 15.2
 **Version Control:** Git
 **UI Framework:** SwiftUI
 **Database:** Swift Data 
 **Networking:** URLSession 

## Technology
### Architecture 
- I used a flavor of mvvm. Since SwiftUI already implements a lot of reactivity(with Combine cooked into it), writing View Models for every view can be counterproductive. I therefore stuck to bareboned models and did most of the work in the views.

### Concurrency
- I used Async await as opposed to the commonly used completion handlers. Async await handles error handling very elegantly. I used a main actor for the view models since it runs on the main loop(which is typically used to update the view)

## App Features 
* Show a list of all saved locations and the weather at the current location 
* Once you tap on a location you view the current weather and the weather forecast of the location]
* while viewing a location detail, tap on the favorite button to toggle it 
* Save a location after tapping on it on the map 


