//
//  UIViewController+Extension.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import UIKit


protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert)
}


extension UIViewController {
    
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController{
    
    func showInternetAlert() {
        
        let okAlert = SingleButtonAlert (
            title: "Could not connect to  network and try again later",
            message: "Failed to update information.",
            action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
        )
        
            presentSingleButtonDialog(alert: okAlert)
        
    }
    
    
    func showLocationAlert(){
    
     let locationAlert = SingleButtonAlert (
        title: "Could not find location",
        message: "Enable location for this App. Go to setting page",
        action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") }))
       presentSingleButtonDialog(alert: locationAlert)
    
    }
    
}

//class TopSlideView: NSObject {
//
//    private static var window: UIWindow?
//    private  var notifierView:UIView?
//    private  var titlelabel:UILabel?
//
//     static func addTopView()  {
//
//        let screen = UIScreen.main.bounds
//        window = UIApplication.shared.delegate!.window!
//        notifierView? = UIView()
//        notifierView?.backgroundColor = .red
//        notifierView?.frame = CGRect(x: 0, y: 0, width: screen.width, height:screen.height * 0.1 )
//        notifierView?.autoresizingMask = [.flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin,.flexibleRightMargin]
//        window!.addSubview(notifierView!)
//
//        titlelabel = UILabel()
//        titlelabel?.text = "You Are Out Of Net Connection"
//        titlelabel!.textAlignment = .center
//        titlelabel!.autoresizingMask = [.flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin,.flexibleRightMargin]
//        titlelabel!.frame = notifierView!.bounds
//        notifierView!.addSubview(titlelabel!)
//
//
//    }

    
//    static func setInternetStatus(status:Bool){
//        if status == true{
//            print("MammaStyle")
//         } else {
//          print("false")
//        }
//
//}
//}


