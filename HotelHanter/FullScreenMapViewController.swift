//
//  FullScreenMapViewController.swift
//  HotelHanter
//
//  Created by Абай Бауржан on 01.12.2024.
//

import UIKit
import MapKit
import CoreLocation



class FullScreenMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var hotelLocation: CLLocation?
    var appleCampusLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Убедитесь, что координаты передаются
        if let hotelLocation = hotelLocation, let appleCampusLocation = appleCampusLocation {
            showRoute(from: appleCampusLocation, to: hotelLocation)
        } else {
            print("Ошибка: не переданы координаты для отеля или Apple Campus.")
        }

        mapView.delegate = self // Убедитесь, что делегат карты установлен
    }

    private func showRoute(from startLocation: CLLocation, to endLocation: CLLocation) {
        let startCoordinate = startLocation.coordinate
        let endCoordinate = endLocation.coordinate

        // Создаем аннотации для маршрута
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = startCoordinate
        startAnnotation.title = "Apple Campus"
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = endCoordinate
        endAnnotation.title = "Hotel"
        
        mapView.addAnnotations([startAnnotation, endAnnotation])

        // Прокладываем маршрут
        let startPlacemark = MKPlacemark(coordinate: startCoordinate)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPlacemark)
        request.destination = MKMapItem(placemark: endPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating route: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                print("No routes found.")
                return
            }
            
            // Добавляем маршрут на карту
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
}

extension FullScreenMapViewController: MKMapViewDelegate {
    // Настроим рендеринг маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5.0
        return renderer
    }
}
