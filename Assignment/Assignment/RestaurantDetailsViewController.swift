//
//  RestaurantDetailsViewController.swift
//  Assignment
//
//  Created by Daniel Mcnamara on 16/02/2018.
//  Copyright © 2018 Daniel Mcnamara. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   
    var locations = [Restaurant]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var ratingImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = theRestaurant?.BusinessName
        detailsLabel.text = "Address Line 1: \(theRestaurant!.AddressLine1) \n Address Line 2: \(theRestaurant!.AddressLine2) \n Address Line 3: \(theRestaurant!.AddressLine3) \n Postcode: \(theRestaurant!.PostCode)"
        
        let ratingValue = theRestaurant!.RatingValue
        ratingImage.image = UIImage(named: ratingValue)
        
        ratingDate.text = "Date of the rating: \(theRestaurant!.RatingDate)"
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                let locality = firstLocation?.locality
            }
            else {
                if let error = error {
                    print("error with reverse eo-coding \n \(error)")
                }
            }
        })
        
        myMapView.delegate = self
        let lat = Double(theRestaurant!.Latitude)
        let lon = Double(theRestaurant!.Longitude)
        
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!,longitude: lon!)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapView.setRegion(region, animated:true)
        
         let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(lat!)&long=\(lon!)")
        
        
        let annotation = CustomPin()
        let ratingVal = "pin\(theRestaurant!.RatingValue)"
        annotation.image = UIImage(named: ratingVal)
        annotation.coordinate = location
        annotation.title = theRestaurant?.BusinessName
        annotation.subtitle = theRestaurant!.DistanceKM
        myMapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !annotation.isKind(of:MKUserLocation.self) else { return nil }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        let customPointAnnotation = annotation as! CustomPin
        annotationView!.image = customPointAnnotation.image
        return annotationView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var ratingDate: UILabel!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var theRestaurant: Restaurant?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
