//
//  InterfaceController.swift
//  CountMyStrokes WatchKit Extension
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
    @IBOutlet weak var holeLabel: WKInterfaceLabel!
    @IBOutlet weak var roundScoreLabel: WKInterfaceLabel!
    @IBOutlet weak var holeStrokesLabel: WKInterfaceLabel!
    @IBOutlet weak var previousHoleButton: WKInterfaceButton!
    @IBOutlet weak var nextHoleButton: WKInterfaceButton!
    
    var watchSession: WCSession?
    
    let defaults = UserDefaults.standard
    var gameManager = GameManager()
    
    override func awake(withContext context: Any?) {
        if (WCSession.isSupported()) {
            watchSession = WCSession.default
            watchSession?.delegate = self
            watchSession?.activate()
        }
        updateScreen()
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
        holeLabel.setText("Hole #\(gameManager.currentHoleIndex + 1)")
        holeStrokesLabel.setText("Strokes: \(gameManager.getCurrentHole().totalStrokesTaken)")
        roundScoreLabel.setText("    Score: \(gameManager.game.totalScore)")
        
        if gameManager.currentHoleIndex > 0 {
            previousHoleButton.setTitle("Hole #\(gameManager.currentHoleIndex)")
            previousHoleButton.setAlpha(1)
        } else {
            previousHoleButton.setAlpha(0)
        }
        if gameManager.currentHoleIndex < 17 {
            nextHoleButton.setTitle("Hole #\(gameManager.currentHoleIndex + 2)")
            nextHoleButton.setAlpha(1)
        } else {
            nextHoleButton.setAlpha(0)
        }
    }
    
    func updatePhone() {
        if let safeSession = watchSession {
            if safeSession.activationState == .activated {
                print("Watch - updateWatch()")
                if safeSession.isReachable {
                    WCSession.default.sendMessageData(gameManager.getData()!) { response in
                        print("Response: \(response)")
                    } errorHandler: { error in
                        print("Error sending data to phone: \(error)")
                    }
                } else {
                    do {
                        print("Watch - updateApplicationContext()")
                        try WCSession.default.updateApplicationContext(["gameManager": gameManager.getData()!])
                    } catch {
                        print("Error sending data to phone: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func decrementStrokesTaken() {
        gameManager.decrementCurrentHoleStrokesTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func incrementStrokesTaken() {
        gameManager.incrementCurrentHoleStrokesTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func decrementChipsTaken() {
        gameManager.decrementCurrentHoleChipsTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func incrementChipsTaken() {
        gameManager.incrementCurrentHoleChipsTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func decrementPutsTaken() {
        gameManager.decrementCurrentHolePutsTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func incrementPutsTaken() {
        gameManager.incrementCurrentHolePutsTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func decrementPenaltiesTaken() {
        gameManager.decrementCurrentHolePenaltiesTaken()
        updateScreen()
        updatePhone()
    }
    
    @IBAction func incrementPenaltiesTaken() {
        gameManager.incrementCurrentHolePenaltiesTaken()
        updateScreen()
        updatePhone()
    }
    @IBAction func previousHoleButtonPressed() {
        let didWork = gameManager.previousHole()
        if didWork {
            updateScreen()
            updatePhone()
        } else {
            print("No previous holes!")
        }
    }
    @IBAction func nextHoleButtonPressed() {
        let didWork = gameManager.nextHole()
        if didWork{
            updateScreen()
            updatePhone()
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch - activationDidCompleteWith")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("Watch - didReceiveMessageData")
        gameManager.importData(data: messageData)
        updateScreen()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Watch - didReceiveApplicationContext")
        gameManager.importData(data: applicationContext["gameManager"] as! Data)
        updateScreen()
    }
}
