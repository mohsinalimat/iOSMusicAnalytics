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
    @IBOutlet weak var authorizeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureButton(using: 10.0, borderColor: nil, borderWidth: nil, with: authorizeButton)
    }
    
    func authorize(){
        MPMediaLibrary.requestAuthorization() { auth in
            if auth == .authorized{
                DispatchQueue.main.async {
                    if noMusicAlert(){
                        let alert = UIAlertController(title: "No Music Found",
                                                      message: "Oops! We did not find music on your local music library. Try adding some music to your music library with iTunes!",
                                                      preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(cancelAction)
                        alert.view.tintColor = myOrange()
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.switchToMain()
                }
            }
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func switchToMain(){
        let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
        appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
    }

    @IBAction func beginAuthorization(_ sender: UIButton) {
        authorize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

