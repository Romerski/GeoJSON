//
//  ViewController.swift
//  GeoJSON
//
//  Created by Yeray Romero on 10/1/17.
//  Copyright © 2017 Yeray Romero. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    

    var timeAgo = "hour"
    var magnitude = "significant"
    var mag: String = "magnitude 1.0+"
    var mapView: GMSMapView!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)! ,longitude: (manager.location?.coordinate.longitude)!, zoom: 6)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
        ///Llamamos a la funcion para obtener los terremotos
        getTerremotos()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        if segue.identifier == "save" {
            let origen = segue.source as! SettingsViewController
            //Guardo en las variables el valor de la variable del controlador de origen.
            timeAgo = origen.timeAgo
            magnitude = origen.magnitude
            
            //Llamamos a la funcion para obtener los terremotos
            getTerremotos()
        }
    }
    
    //Función para mostrar alerts
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Función para obtener los terremotos dependiendo de los parámetros.
    func getTerremotos(){
        let url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/"+magnitude+"_"+timeAgo+".geojson"
        Alamofire.request(url,method:.get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //Parseo el JSON obtenido.
                let terremotos = JSON(value)
                //Obtengo el número de terremotos.
                let count = Int(terremotos["metadata"]["count"].stringValue)
                //Establezco el valor de la variable dependiendo de los parámetros especificados.
                if (self.magnitude == "all") {
                    self.mag = "all magnitudes"
                } else if (self.magnitude == "significant") {
                    self.mag = "significant magnitude"
                } else {
                    self.mag = "magnitude \(self.magnitude)+"
                }
                //Controlo si tengo al menos un terremoto
                if (count! > 0) {
                    //Limpio el mapa de posibles marcadores.
                    self.mapView.clear()
                    //Creo una alerta informando de los terremotos encontrados con los parámetros especificados.
                    let title = "Success!"
                    let msg = "\(count!) earthquakes found with \(self.mag) in the past \(self.timeAgo.lowercased())."
                    self.showAlert(title: title, msg: msg)
                    //Bucle para crear todos los marcadores.
                    for i in 1...count! {
                        //Obtengo información del terromoto
                        let longitude = terremotos["features"][i-1]["geometry"]["coordinates"][0].floatValue
                        let latitude = terremotos["features"][i-1]["geometry"]["coordinates"][1].floatValue
                        let title = terremotos["features"][i-1]["properties"]["place"].stringValue
                        let magnitude = terremotos["features"][i-1]["properties"]["mag"].stringValue
                        let status = terremotos["features"][i-1]["properties"]["status"].stringValue
                        let date = Date.init(timeIntervalSince1970: terremotos["features"][i-1]["properties"]["time"].doubleValue/1000)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium
                        let dateFinal = dateFormatter.string(from: date)
                        //Creo el marcador
                        let position = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
                        let marker = GMSMarker(position: position)
                        //Título y descripción
                        marker.title = title
                        marker.snippet = "Magnitude: " + magnitude + "\nDate: " + dateFinal + "\nStatus: " + status
                        marker.map = self.mapView
                    }
                }
                //Alerta si no se encuentra ningún terremoto con los parámetros especificados.
                else {
                    let title = "Woops!"
                    let msg = "The are no earthquakes with \(self.mag) in the past \(self.timeAgo.lowercased()). Try to change search parameters in settings."
                    self.showAlert(title: title, msg: msg)
                }
            case .failure(let error):
                let title = "Woops!"
                self.showAlert(title: title, msg: error as! String)
            }
        }
    }
    
}

