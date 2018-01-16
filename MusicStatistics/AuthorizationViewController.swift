//
//  AuthorizationViewController.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/15/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AuthorizationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if MPMediaLibrary.authorizationStatus() == .authorized {
            authSegue()
        }
    }
    
    func authorize(){
        let status = MPMediaLibrary.authorizationStatus()
        if status == .notDetermined || status == .denied {
            MPMediaLibrary.requestAuthorization() { auth in
                if auth == .authorized{ self.authSegue() }
            }
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func authSegue(){
        DispatchQueue.main.async { [unowned self] in
            self.performSegue(withIdentifier: "authorized", sender: self)
        }
    }

    @IBAction func beginAuthorization(_ sender: UIButton) {
        authorize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
