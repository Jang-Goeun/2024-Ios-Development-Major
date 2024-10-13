//
//  ViewController.swift
//  myMapTest
//
//  Created by 장고은 on 10/13/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLcationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    @IBOutlet var addressTextField: UITextField!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        lblLcationInfo1.text = "위도/경도:"
        lblLocationInfo2.text = "주소:"

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        myMap.showsUserLocation = true
    }

    // 위치 이동 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }

    // 지도에 핀(Annotation) 추가 함수
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }

    // 위치 업데이트 시 호출되는 함수 (현재 위치 기반으로 지도 업데이트)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let pLocation = locations.last else { return }
        let latitude = pLocation.coordinate.latitude
        let longitude = pLocation.coordinate.longitude

        _ = goLocation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.01)

        // 위도/경도 표시
        lblLcationInfo1.text = "위도/경도: \(latitude) / \(longitude)"

        // 주소 표시
        geocoder.reverseGeocodeLocation(pLocation, completionHandler: {
            (placemarks, error) -> Void in
            if let error = error {
                print("주소 변환 실패: \(error.localizedDescription)")
                return
            }
            guard let pm = placemarks?.first else { return }
            let country = pm.country ?? ""
            var address = country
            if let locality = pm.locality {
                address += " " + locality
            }
            if let thoroughfare = pm.thoroughfare {
                address += " " + thoroughfare
            }

            self.lblLocationInfo2.text = "주소: \(address)"
            self.setAnnotation(latitudeValue: latitude, longitudeValue: longitude, delta: 0.01, title: "현재 주소", subtitle: address)
        })
        
        locationManager.stopUpdatingLocation()
    }

    // 현재 위치 버튼 클릭 시 호출
    @IBAction func btnCurrentLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation() // 현재 위치 업데이트 시작
    }

    // 이동 버튼 클릭 시 호출 (입력된 주소를 기반으로 지도 이동 및 핀 추가)
    @IBAction func btnChangeLocation(_ sender: UIButton) {
        guard let address = addressTextField.text, !address.isEmpty else {
            print("주소를 입력해주세요")
            return
        }

        // 입력된 주소를 기반으로 지오코딩
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let error = error {
                print("지오코딩 에러: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("주소 변환 실패")
                return
            }

            let coordinate = location.coordinate
            _ = self?.goLocation(latitudeValue: coordinate.latitude, longitudeValue: coordinate.longitude, delta: 0.01)

            // 지도에 핀 추가
            self?.setAnnotation(latitudeValue: coordinate.latitude, longitudeValue: coordinate.longitude, delta: 0.01, title: "입력한 주소", subtitle: address)

            // 위도/경도 및 주소 정보 레이블 업데이트
            self?.lblLcationInfo1.text = "위도/경도: \(coordinate.latitude) / \(coordinate.longitude)"
            self?.lblLocationInfo2.text = "주소: \(address)"
        }
    }
}
