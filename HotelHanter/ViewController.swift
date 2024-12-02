//
//  ViewController.swift
//  HotelHanter
//
//  Created by Абай Бауржан on 01.12.2024.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapButton: UIButton!
    
    
    var hotel = Hotel(name: "", price: "", imageName: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    let appleCampusLocation = CLLocation(latitude: 37.3349, longitude: -122.0090) // Координаты Apple Campus
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = hotel.name
        priceLabel.text = hotel.price
        imageView.image = UIImage(named: hotel.imageName)

        setupMap()
    }

    private func setupMap() {
        // Создаем аннотацию для выбранного отеля
        let hotelLocation = CLLocation(latitude: hotel.coordinate.latitude, longitude: hotel.coordinate.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = hotelLocation.coordinate
        annotation.title = hotel.name
        mapView.addAnnotation(annotation)
        
        // Устанавливаем регион для отображения карты
        let region = MKCoordinateRegion(center: hotelLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }

    @IBAction func mapButtonTapped(_ sender: UIButton) {
        let fullMapVC = storyboard?.instantiateViewController(withIdentifier: "FullScreenMapViewController") as! FullScreenMapViewController
        fullMapVC.hotelLocation = CLLocation(latitude: hotel.coordinate.latitude, longitude: hotel.coordinate.longitude)
        fullMapVC.appleCampusLocation = appleCampusLocation
        navigationController?.pushViewController(fullMapVC, animated: true)
    }
}
