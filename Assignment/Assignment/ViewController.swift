//
//  ViewController.swift
//  Assignment
//
//  Created by Daniel Mcnamara on 16/02/2018.
//  Copyright © 2018 Daniel Mcnamara. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTheRestaurant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        cell.textLabel?.text = "\(allTheRestaurant[indexPath.row].BusinessName)"
        let ratingvalue = allTheRestaurant[indexPath.row].RatingValue
        cell.imageView?.image = UIImage(named: ratingvalue)


        return cell
    }
    
    
    var allTheRestaurant = [Restaurant]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
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
        
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude!)&long=\(longitude!)")
        
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            
            guard let data = data else { print("error with data"); return }
            do{
                self.allTheRestaurant = try JSONDecoder().decode([Restaurant].self, from: data);
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData();
                }
                
            } catch let err {
                print("Error:" , err)
            }
            }.resume()
        
           searchView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let cell = sender as? UITableViewCell{
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "details" {
                let dvc = segue.destination as! RestaurantDetailsViewController
                dvc.theRestaurant = self.allTheRestaurant[i]
            }
        }
    }
    @IBAction func showSearch(_ sender: Any) {
        if searchView.isHidden {
            searchView.isHidden = false
            print("hidden")
        } else {
            searchView.isHidden = true
            print("unhidden")
        }
    }

    
    @IBAction func searchButton(_ sender: Any) {
        
        let index = searchSegment.selectedSegmentIndex
        
        let userVal = searchBar.text
        
        searchView.isHidden = true
        
        var escapedString = userVal?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if index == 0 {
            
        
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(escapedString!)")
            
            URLSession.shared.dataTask(with: url!){ (data, response, error) in
                
                guard let data = data else { print("error with data"); return }
                do{
                    self.allTheRestaurant = try JSONDecoder().decode([Restaurant].self, from: data);
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData();
                    }
                    
                } catch let err {
                    print("Error:" , err)
                }
                }.resume()
        }
        else{
            
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(escapedString!)")
            URLSession.shared.dataTask(with: url!){ (data, response, error) in
                
                guard let data = data else { print("error with data"); return }
                do{
                    self.allTheRestaurant = try JSONDecoder().decode([Restaurant].self, from: data);
                    
                    DispatchQueue.main.async {
                        self.myTableView.reloadData();
                    }
                    
                } catch let err {
                    print("Error:" , err)
                }
                }.resume()
        }
        
    }
    @IBAction func refreshButton(_ sender: Any) {
        viewDidLoad()
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var search: UIBarButtonItem!
    @IBOutlet weak var searchSegment: UISegmentedControl!
    
    
}

