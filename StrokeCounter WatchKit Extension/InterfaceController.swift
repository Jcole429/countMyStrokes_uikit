//
//  InterfaceController.swift
//  StrokeCounter WatchKit Extension
//
//  Created by Justin Cole on 6/12/21.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var strokesLabel: WKInterfaceLabel!
    @IBOutlet weak var chipsLabel: WKInterfaceLabel!
    @IBOutlet weak var putsLabel: WKInterfaceLabel!
    @IBOutlet weak var penaltiesLabel: WKInterfaceLabel!
    
    var watchSession: WCSession?
    
    let defaults = UserDefaults.standard
    var gameManager = GameManager()
    
    override func awake(withContext context: Any?) {
        if (WCSession.isSupported()) {
            watchSession = WCSession.default
            watchSession?.delegate = self
            watchSession?.activate()
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("Watch - willActivate()")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print("Watch - didDeactivate()")
    }
    
    func updateScreen() {
        print("Watch - updateScreen()")
        strokesLabel.setText("Strokes: \(gameManager.getCurrentHole().strokesTaken)")
        chipsLabel.setText("Chips: \(gameManager.getCurrentHole().chipsTaken)")
        putsLabel.setText("Puts: \(gameManager.getCurrentHole().putsTaken)")
        penaltiesLabel.setText("Penalties: \(gameManager.getCurrentHole().penaltiesTaken)")
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch - activationDidCompleteWith")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch - didReceiveApplicationContext: \(applicationContext)")
        gameManager.importData(data: applicationContext["gameManager"] as! Data)
        updateScreen()
    }
}
