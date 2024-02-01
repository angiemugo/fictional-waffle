//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

struct WeatherDetailView: View {
    @StateObject var detailVM: WeatherDetailViewModel
    @Environment(\.modelContext) var modelContext
    let todayModel: TodayWeatherUIModel

    var body: some View {
        switch detailVM.state {
        case .idle:
            Color.clear.onAppear {
                Task {
                    await detailVM.onAppearAction(todayModel.lat, todayModel.lon)
                }
            }
        case .loading:
            ProgressView()
        case .failed(let error):
            Text("This is the error \(error.localizedDescription)")
        case .loaded(let forecastData):
            VStack {
                ZStack(alignment: .top) {
                    Image(todayModel.backgroundImage)
                        .resizable().aspectRatio(contentMode: .fill)
                    HStack {
                        Text(todayModel.locationName)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                        .padding()
                        Button {
                            toggleFavorite()
                        } label: {
                            Image(systemName: todayModel.isFavourite ? "bookmark.fill" : "bookmark")
                        }
                    }
                }
                HStack {
                    VStack {
                        Text(todayModel.min)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        Text("Min")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }

                    VStack {
                        Text(todayModel.current)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)

                        Text("Current")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    }

                    VStack {
                        Text(todayModel.max)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                        Text("Max")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                    }
                }.padding(.horizontal)
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                List {
                    ForEach(forecastData.sorted(by: { $0.value.first!.dtTxt < $1.value.first!.dtTxt }), id: \.key) { model in
                        HStack {
                            Text(model.key)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            model.value.first?.weather
                            Text(model.value.first?.temp ?? "")
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                        }
                    }
                }.listStyle(.plain)
            }.background(Color.blue)
        }
    }

    func toggleFavorite() {
        todayModel.isFavourite.toggle()
        if todayModel.isFavourite {
            modelContext.insert(todayModel)
        } else {
            modelContext.delete(todayModel)
        }
    }
}

//#Preview {
//    ContentView(, weatherService: <#WeatherService#>)
//}
