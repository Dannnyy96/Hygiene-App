//
//  MapView.swift
//  Assignment
//
//  Created by Daniel Mcnamara on 23/02/2018.
//  Copyright © 2018 Daniel Mcnamara. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

     var locations = [Restaurant]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myMapView.delegate = self
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMapView.setRegion(region, animated:true)
        
       let annotation1 = CustomPin()
        annotation1.image = UIImage(named: "pinforuser")
        annotation1.coordinate = CLLocationCoordinate2D(latitude: latitude!,longitude: longitude!)
        annotation1.title = "Your location"
        
        self.myMapView.addAnnotation(annotation1)
        
         let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude!)&long=\(longitude!)")
        
            do{
                let data = try Data(contentsOf: url!)
                self.locations = try JSONDecoder().decode([Restaurant].self, from: data)
                print(self.locations.count)
            }catch let err {
                print(err)
            }
            
            for l in self.locations {
                
                let annotation = CustomPin()
                let lat = Double(l.Latitude)
                let lon = Double(l.Longitude)
                let ratingvalue = "pin\(l.RatingValue)"
                annotation.image = UIImage(named: ratingvalue)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!,longitude: lon!)
                annotation.title = l.BusinessName
                annotation.subtitle = l.DistanceKM
                self.myMapView.addAnnotation(annotation)
            }
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
