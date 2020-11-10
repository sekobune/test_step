//
//  MapViewController.swift
//  PuppyStep
//
//  Created by Sergey on 10/9/20.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit
import Kingfisher

class MapSearchViewController: UIViewController {

    private var presenter: MapSearchViewPresenter!

    private let disposeBag = DisposeBag()
    
    //NOTE: Can I store this var here or for DogInfo openning I must create request to storage
    private var currentDog: Dog?
    
    //MARK: - Views init
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        let initialLocation = CLLocation(latitude: 53.893009, longitude: 27.567444)
        mapView.centerToLocation(initialLocation, regionRadius: 12000)
        return mapView
    }()
    private let messageAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Warning!",
            message: "",
            preferredStyle: .alert
        )
        return alert
    }()
    
    //NOTE: Should I create custom view?
    private lazy var currentDogView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainSecond()
        view.isHidden = true
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(roundedRect:view.bounds, cornerRadius:view.layer.cornerRadius).cgPath
        return view
    }()
    private lazy var currentDogNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 40)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .right
        return label
    }()
    private lazy var currentDogImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var currentDogViewGesture: UIGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    //NOTE: Should I create custom view?
    private lazy var currentWeatherView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainSecond()
        view.isHidden = true
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.layer.shadowPath = UIBezierPath(roundedRect:view.bounds, cornerRadius:view.layer.cornerRadius).cgPath
        return view
    }()
    private lazy var currentWeatherTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 28)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .left
        return label
    }()
    private lazy var currentWeatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubviews()
        arrangeSubviews()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentDogView.roundTopCorners(cornerRadius: 50)
        currentDogImage.layer.cornerRadius = 0.5 * currentDogImage.bounds.size.height
        currentDogImage.clipsToBounds = true
        
        currentWeatherView.roundBottomCorners(cornerRadius: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentDogView.isHidden = true
        currentWeatherView.isHidden = true
        self.currentDog = nil
        
        presenter.getDogHoldersData()
        presenter.getCurrentDog()
        presenter.getCurrentWeather()
    }
    
}

//MARK: - UI
private extension MapSearchViewController {
    
    func setupView() {
        mapView.delegate = self
        currentDogView.addGestureRecognizer(currentDogViewGesture)
    }
    
    func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(currentDogView)
        view.addSubview(currentWeatherView)
        currentDogView.addSubview(currentDogNameLabel)
        currentDogView.addSubview(currentDogImage)
        currentWeatherView.addSubview(currentWeatherTitleLabel)
        currentWeatherView.addSubview(currentWeatherImage)
    }

    func arrangeSubviews() {
        mapView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        currentDogView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.snp.centerY).offset(self.view.bounds.height/3)
        }
        
        currentDogImage.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(currentDogView.snp.height).dividedBy(1.5)
        }
        
        //inset vs offset
        currentDogNameLabel.snp.makeConstraints{ make in
            make.leading.equalTo(currentDogImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        currentWeatherView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.view.snp.centerY).offset(self.view.bounds.height / -3)
        }
        
        currentWeatherTitleLabel.snp.makeConstraints{ make in
            make.leading.centerY.equalToSuperview().offset(30)
        }
        
        currentWeatherImage.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(20)
            make.width.height.equalTo(currentWeatherView.snp.height).dividedBy(1.5)
        }
    }
    
    func setupActions() {
        
        let alertAction = UIAlertAction(title: "Retry", style: .default) { action in
            self.presenter.getDogHoldersData()
        }
        messageAlert.addAction(alertAction)
        
        currentDogViewGesture.rx.event
            .bind(onNext: { recognizer in
                self.presenter.navigateToDogInfoScreen(dog: self.currentDog!)
            })
            .disposed(by: disposeBag)
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 3000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension MapSearchViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        
        guard let annotation = annotation as? DogHolder else {
            return nil
        }
        
        let identifier = "dogholder"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            button.setImage(UIImage(named: "LogoImage"), for: .normal)
            button.rx.tap
                .bind {
                    self.presenter.navigateToDetailsScreen(selectedDogHolder: annotation)
                }
                .disposed(by: disposeBag)
            view.rightCalloutAccessoryView = button
            
//            view.glyphImage = UIImage(named: "LogoImage")
//            view.markerTintColor = UIColor.mainSecond()
        }
        view.glyphImage = UIImage(named: "LogoImage")
        view.markerTintColor = UIColor.mainSecond()
        return view
    }
}

//MARK: - View contract
extension MapSearchViewController: MapSearchView {
        
    func configure(presenter: MapSearchViewPresenter) {
        self.presenter = presenter
    }
    
    func showDogHoldersData(dogHolders: [DogHolder]) {
        mapView.addAnnotations(dogHolders)
    }
    
    func showMessage(message: String) {
        messageAlert.message = "Can't find any dog holders. Do you want retry?"
        self.present(messageAlert, animated: true, completion: nil)
    }
    
    func showCurrentDog(currentDog: Dog) {
        self.currentDog = currentDog
        currentDogNameLabel.text = currentDog.name
        let processor = RoundCornerImageProcessor(cornerRadius: 0.5 * currentDogImage.bounds.size.height)

        currentDogImage.kf.setImage(
            with: URL(string: currentDog.photoUrl!),
            placeholder: UIImage(named: "LogoImage"),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        currentDogView.isHidden = false
    }
    
    func showWeatherInfo(weather: WeatherInfo) {
        let weatherInfo = weather.weather[0]
        currentWeatherTitleLabel.text = "\(weatherInfo.weatherTitle) \(weather.temperature)F"
        print(weatherInfo.iconUrl)

        currentWeatherImage.kf.setImage(
            with: URL(string: weatherInfo.iconUrl),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        currentWeatherView.isHidden = false
    }
}
