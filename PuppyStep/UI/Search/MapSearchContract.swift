//
//  SearchContract.swift
//  PuppyStep
//
//  Created by Sergey on 10/28/20.
//

import Foundation

//MARK: - View contract
protocol MapSearchView {
    func configure(presenter: MapSearchViewPresenter)
    func showDogHoldersData(dogHolders: [DogHolder])
    func showCurrentDog(currentDog: Dog)
    func showWeatherInfo(weather: WeatherInfo)
    func showMessage(message: String)
}

//MARK: - Presenter contract
protocol MapSearchViewPresenter {
    init(view: MapSearchView, coordinator: AppCoordinator)
    func getDogHoldersData()
    func getCurrentDog()
    func getCurrentWeather()
    func navigateToDogInfoScreen(dog: Dog)
    func navigateToDetailsScreen(selectedDogHolder: DogHolder)
}
