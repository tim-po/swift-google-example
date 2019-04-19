//
//  MapViewController.swift
//  
//
//  Created by Тимофей on 18/09/2018.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import Alamofire

let colors = Colors()

class MapViewController: UIViewController{
    
    var places: [GooglePlace] = []
    
    var lightCafeArray: [[String: Any]] = []
    
    var cafeList: [Cafe] = []
    
    
    @IBAction func updatePan(_ sender: UIPanGestureRecognizer) {
        print("update")
        fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapView.clear()
        
        let url = "http://192.168.43.232:8000/cafes/get_cafe_by_coord?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&r=10000000000000000000"
        
        Alamofire.request(url).responseJSON{
            response in
            
            if let json = response.result.value {
                self.lightCafeArray = json as! [[String: Any]]
                
                for cafe in self.lightCafeArray{
                    let cafe = Cafe(withArrayInLightForm: cafe)
                    let place = GooglePlace(fromCafe: cafe)
                    self.places.append(place)
                    let marker = CafeGMSMarker(withCafe: cafe, withCoordinates: place.coordinate)
                    marker.icon = #imageLiteral(resourceName: "mapObjectDefault")
                    marker.snippet = cafe.name
                    marker.map = self.mapView
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.barTintColor = colors.main
        self.tabBarController?.tabBarItem.badgeColor = colors.secondary
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cafeMenueSegue"
        {
            if let destinationVC = segue.destination as? Busines {
                destinationVC.cafeId = (sender as! CafeGMSMarker).cafe.name
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        fetchNearbyPlaces(coordinate: location.coordinate)
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let cafeMarker = marker as! CafeGMSMarker
        if cafeMarker.alreadyEvBeenTaped{
            performSegue(withIdentifier: "cafeMenueSegue", sender: marker as! CafeGMSMarker)
        }
        else{
            cafeMarker.alreadyEvBeenTaped = true
            marker.icon = #imageLiteral(resourceName: "doggo")
            mapView.camera = GMSCameraPosition(target: cafeMarker.position, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        return true
    }
}

