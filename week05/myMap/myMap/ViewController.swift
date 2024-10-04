//
//  ViewController.swift
//  myMap
//
//  Created by CSMAC11 on 10/4/24.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    @IBOutlet var inputText: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
    }

    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue:CLLocationDegrees, delta span:Double) -> CLLocationCoordinate2D{
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _=goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        
        
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = "주소: "
            address += country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo2.text = address
        })
        
        CLGeocoder().geocodeAddressString(address!, completionHandler: { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error)")
                    return
                }

                guard let placemark = placemarks?.first,
                      let location = placemark.location else {
                    print("No location found")
                    return
                }

            let latitude: Double = location.coordinate.latitude
            let latitudeString:String = String(latitude)
            let longitude = location.coordinate.longitude
            let longitudeString:String = String(longitude)

            self.lblLocationInfo1.text = add
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func geocodeAddress(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error)")
                    return
                }

                guard let placemark = placemarks?.first,
                      let location = placemark.location else {
                    print("No location found")
                    return
                }

                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude

                self?.displayCoordinates(latitude: latitude, longitude: longitude)
            }
        }
    @IBAction func btnChangeLocation1(_ sender: UIButton) {
    }
    
    @IBAction func btnChangeLocation2(_ sender: UIButton) {
    }
}

