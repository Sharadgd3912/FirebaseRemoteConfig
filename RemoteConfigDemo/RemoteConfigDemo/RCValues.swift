//
//  RCValues.swift
//  RemoteConfigDemo
//
//  Created by Sharad Saxena on 08/05/20.
//  Copyright © 2020 Idemia. All rights reserved.
//

import Foundation
import Firebase

class RCValues {

  static let sharedInstance = RCValues()

  private init() {
    //loadDefaultValues()
    fetchCloudValues()
  }

    func loadDefaultValues() {
        if let versionJSON = getAppVersionJson(){
            let appDefaults: [String: Any?] = [
                "iOSAppVersion" : versionJSON
            ]
            RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
        }
    }
    
    
    func fetchCloudValues() {
      // 1
      // WARNING: Don't actually do this in production!
      let fetchDuration: TimeInterval = 0
        // for development purpose
        //activateDebugMode()
      RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { status, error in

        if let error = error {
          print("Uh-oh. Got an error fetching remote values \(error)")
          return
        }

        // 2
        RemoteConfig.remoteConfig().activate(completionHandler: nil)
        print("Retrieved values from the cloud!")
      }
    }
    
//    func activateDebugMode() {
//       let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
//        RemoteConfig.remoteConfig().configSettings = debugSettings
//    }
    
    func getAppVersionJson() -> String?{
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let forceUpdate = true
        let versionList = [appVersion!, buildVersion!, forceUpdate] as [Any]
        let versionDictionary = ["ios": versionList] as [String : Any]
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: versionDictionary,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            return theJSONText
        }
        return ""
    }
}
