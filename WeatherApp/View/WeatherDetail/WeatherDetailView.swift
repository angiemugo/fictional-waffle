//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Angie Mugo on 29/01/2024.
//
import SwiftUI
import SwiftData

struct WeatherDetailView: View {
    @StateObject var detailVM: WeatherDetailViewModel
    @Environment(\.modelContext) var modelContext
    let todayModel: TodayWeatherUIModel
    let isFave: Bool

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
                Image(BackgroundImage.create(rawValue: todayModel.desc).background)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
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
                ForEach(forecastData.sorted(by: { $0.value.first!.dtTxt < $1.value.first!.dtTxt }), id: \.key) { model in
                    HStack {
                        Text(model.key)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        model.value.first?.weather
                        Text(model.value.first?.temp ?? "")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                    }.padding(.vertical, 5)
                        .padding(.horizontal)
                }
                Spacer()
            }
            .background(WeatherColor.create(rawValue: todayModel.desc).color)
            .navigationTitle(todayModel.locationName)
            .toolbar {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: isFave ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }

    func toggleFavorite() {
        if isFave {
            modelContext.delete(todayModel)
        } else {
            modelContext.insert(todayModel)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TodayWeatherUIModel.self, configurations: config)

    return WeatherDetailView(detailVM: WeatherDetailViewModel(dataSource: RemoteDataSource(WeatherClient())), todayModel: PreviewData.shared.getFavoriteUIModel(), isFave: false).modelContainer(container)
}
