//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SimpleCameraController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods
    
    @IBAction func capture(sender: UIButton) {
    }

    // MARK: - Segues
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }

}
