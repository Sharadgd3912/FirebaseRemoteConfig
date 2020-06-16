//
//  ViewController.swift
//  RemoteConfigDemo
//
//  Created by Sharad Saxena on 08/05/20.
//  Copyright © 2020 Idemia. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func checkAppVerion(_ sender: UIButton) {
        let latestVersions = RemoteConfig.remoteConfig()
            .configValue(forKey: "latestAppVersion")
        let json =  latestVersions.jsonValue as! [String: Any]
        let versionsList = json["ios"] as? [Any]
        let majorVersion = versionsList?[0] as! String
        let minorVersion = versionsList?[1] as! String
        print("Our app's latest major Version is \(majorVersion)")
        print("Our app's latest minor Version is \(minorVersion))")
        checkversion(controller:self, remoteVersion: majorVersion)
    }
 
    
    func checkversion(controller:UIViewController, remoteVersion: String){
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! NSString//localversion
//        itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=YOUR_APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software
        let url = URL(string: "https://www.google.com/")
        let appStore = remoteVersion//newversion
        //Compare
        let versionCompare = currentVersion.compare(appStore as String, options: .numeric)
        if versionCompare == .orderedSame {
            print("same version")
        } else if versionCompare == .orderedAscending {
            
            let alertc = UIAlertController(title: "UPDATE!!", message: "New Version: \(remoteVersion)", preferredStyle: .alert)
            let alertaction = UIAlertAction(title: "Update", style: .default, handler: { (ok) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (ok) in
                controller.dismiss(animated: true, completion: nil)
            })
            alertc.addAction(cancelAction)
            alertc.addAction(alertaction)
            controller.present(alertc, animated: true, completion: nil)
            
        } else if versionCompare == .orderedDescending {
            
        }
    }
}

