# Weather App  
Weather app is a small app that uses the [OpenWeather API](https://openweathermap.org/api) to fetch current weather data and forecast weather data.  

## Sample Screenshots  

<p align="center">
  <img src="https://github.com/user-attachments/assets/606dab37-1ff6-4a2f-81a3-18e7ebff41b1" width="200">
  <img src="https://github.com/user-attachments/assets/4bfd20b6-9f72-42a6-af12-b5e66a2f87cf" width="200">
  <img src="https://github.com/user-attachments/assets/b8bcd863-8fc9-4d62-87d5-e4fbcbc99087" width="200">
  <img src="https://github.com/user-attachments/assets/2011244a-21b4-415d-b7f0-0f2b629363c3" width="200">
</p>  

## Prerequisites  
These are the tools we need to run the project:  
- Xcode 16.2 or newer  
- iOS 18.0 or newer  

## Installation  
```sh
git clone https://github.com/angiemugo/fictional-waffle.git
```

## Getting Started  
1. Open the Xcode project in Xcode.  
2. Build and run the project.  
3. Explore the app on an iOS device to access location services.  
4. The iOS simulator provides a default location, so it's recommended to use a physical device.  

## Project Structure  

```
WeatherApp/
│
├─ WeatherApp/
│   ├── Utils/
│   ├── View/
│   ├── Network/
│   ├── Extensions/
│
├─ WeatherAppTests/
```

## Technologies Used  
- **Programming Language:** Swift  
- **Development Environment:** Xcode 15.2  
- **Version Control:** Git  
- **UI Framework:** SwiftUI  
- **Database:** SwiftData  
- **Networking:** URLSession  

## Technology  

### Architecture  
I used a flavor of MVVM. Since SwiftUI already implements a lot of reactivity (with Combine baked in), writing ViewModels for every view can be counterproductive. I stuck to barebones models and did most of the work in the views.  

### Concurrency  
I used `async/await` instead of completion handlers. `async/await` handles errors elegantly. I used `@MainActor` for the view models since it runs on the main loop (which is typically used to update the view).  

### API Key 
I saved the API key in secrets.plist which I have pushed with this project. In a real-world project, I would not push this since it's sensitive information. 

## App Features  
- Show a list of all saved locations and the weather at the current location.  
- Tap on a location to view the current weather and forecast for that location.  
- While viewing a location’s details, tap on the favorite button to toggle it.  
- Save a location after selecting it on the map.  
