//
//  ViewController.swift
//  SmartDoorBell
//
//  Created by Archerwind on 4/17/17.
//  Copyright © 2017 Archerwind. All rights reserved.
//

import UIKit
//import Spring

class MainViewController: UIViewController {

   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var subtitleLabel: UILabel!
   @IBOutlet weak var ssidTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var ipTextField: UITextField!
   @IBOutlet weak var configButton: UIButton!
   @IBOutlet weak var resetButton: UIButton!
   
   // API Provider
   // let provider = MoyaProvider<GiftpackAPIService>()
   
   @IBAction func resetAction( _ sender: Any ) {
      self.dismiss( animated: true, completion: nil )
   }
   
   @IBAction func configAction( _ sender: Any ) {
      let url = "http://" + self.ipTextField.text! + "/ssid/" + self.ssidTextField.text! + "/" + self.passwordTextField.text!
      var request = URLRequest( url: URL( string: url )! )
      request.httpMethod = "GET"
      let session = URLSession.shared
      
      session.dataTask( with: request ) { data, response, err in
         
      }.resume()
   }
   
   func initializer() {
      self.titleLabel.kern( 2.0 )
      self.subtitleLabel.kern( 1.5 )
      self.configButton.kern( 2.0 )
      self.resetButton.kern( 2.0 )
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.initializer()
   }

   override func viewWillAppear( _ animated: Bool ) {
      
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      
   }
}

