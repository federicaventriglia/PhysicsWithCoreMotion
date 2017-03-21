//
//  LightbulbViewController.swift
//  PhysicsWithCoreMotion
//
//  Created by Simone Martorelli on 21/03/17.
//  Copyright © 2017 Simone Martorelli. All rights reserved.
//

import UIKit
import CoreMotion

class LightbulbViewController: UIViewController {

    let manager: CMMotionManager = CMMotionManager()
    
    @IBOutlet weak var lightbulb: UIImageView!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var alphaValue: UILabel!
    @IBOutlet weak var light: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lightbulb.alpha = 0
        light.alpha = 0
        start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stop()
    }
    
    func start() {
        var newValue: Double = 0.0
        var oldValue: Double = 0.0
        var deltaValue: Double = 0.0

        if manager.isMagnetometerAvailable {
            manager.magnetometerUpdateInterval = 0.5
            manager.startMagnetometerUpdates(to: OperationQueue.main, withHandler: {
                (magnetometerData, error) in
                if error != nil {
                    print("Problems while reading magnetometer data")
                } else {
                    if let data = magnetometerData {
                        oldValue = newValue
                        newValue = data.magneticField.z
                        deltaValue = abs(oldValue) - abs(newValue)
                        DispatchQueue.main.async {
                            if deltaValue > 6 {
                                UIView.animate(withDuration: 0.4, animations: {
                                    self.lightbulb.alpha = 1
                                    self.light.alpha = 1
                                })
                            } else {
                                UIView.animate(withDuration: 0.4, animations: {
                                    self.lightbulb.alpha = CGFloat((deltaValue)/6.0)
                                    self.light.alpha = CGFloat((deltaValue)/6.0)
                                })
                            }
                        }
                    }
                }
                
            })
            
        }
    }
    
    func stop() {
        if manager.isMagnetometerActive {
            manager.stopMagnetometerUpdates()
        }
    }

}
