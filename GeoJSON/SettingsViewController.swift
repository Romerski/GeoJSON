//
//  SettingsViewController.swift
//  GeoJSON
//
//  Created by  on 7/2/17.
//  Copyright © 2017 Yeray Romero. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    
    var timeAgo = "hour"
    var magnitude = "significant"
    
    @IBAction func cambiarValor(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            timeAgo = "hour"
        case 1:
            timeAgo = "day"
        case 2:
            timeAgo = "week"
        case 3:
            timeAgo = "month"
        default:
            break;
        }
    }
    
    @IBAction func cambiarMagnitud(_ sender: UISegmentedControl) {
        switch segment2.selectedSegmentIndex {
        case 0:
            magnitude = "significant"
        case 1:
            magnitude = "4.5"
        case 2:
            magnitude = "2.5"
        case 3:
            magnitude = "1.0"
        case 4:
            magnitude = "all"
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func save(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "save", sender: self)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "cancel", sender: self)
    }
}
