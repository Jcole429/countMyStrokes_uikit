//
//  ViewController.swift
//  StrokeCounter
//
//  Created by Justin Cole on 6/12/21.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalStrokesLabel: UILabel!
    @IBOutlet weak var holeNumLabel: UILabel!
    @IBOutlet weak var strokesLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var putsLabel: UILabel!
    @IBOutlet weak var penaltiesLabel: UILabel!
    
    @IBOutlet weak var strokesStepper: UIStepper!
    @IBOutlet weak var chipsStepper: UIStepper!
    @IBOutlet weak var putsStepper: UIStepper!
    @IBOutlet weak var penaltiesStepper: UIStepper!
    
    var watchSession: WCSession?
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            watchSession = WCSession.default
            watchSession?.delegate = self
            watchSession?.activate()
        }
        
        gameManager.loadGameManager()
        updateWatch()
        updateSteppers()
        updateScreen()
    }
    
    func updateScreen() {
        holeNumLabel.text = "Hole #: \(gameManager.getCurrentHole().holeNumber)"
        totalStrokesLabel.text = "Total Strokes: \(gameManager.getCurrentHole().totalStrokesTaken)"
        strokesLabel.text = "Strokes: \(gameManager.getCurrentHole().strokesTaken)"
        chipsLabel.text = "Chips: \(gameManager.getCurrentHole().chipsTaken)"
        putsLabel.text = "Puts: \(gameManager.getCurrentHole().putsTaken)"
        penaltiesLabel.text = "Penalties: \(gameManager.getCurrentHole().penaltiesTaken)"
        totalScoreLabel.text = "Total Score: \(gameManager.game.totalScore)"
        gameManager.saveGameManager()
    }
    
    func updateSteppers() {
        strokesStepper.value = Double(gameManager.getCurrentHole().strokesTaken)
        chipsStepper.value = Double(gameManager.getCurrentHole().chipsTaken)
        putsStepper.value = Double(gameManager.getCurrentHole().putsTaken)
        penaltiesStepper.value = Double(gameManager.getCurrentHole().penaltiesTaken)
    }
    
    func updateWatch() {
        if let safeSession = watchSession {
            if safeSession.activationState == .activated {
                if safeSession.isReachable {
                    print("Phone - sendMessageData()")
                    WCSession.default.sendMessageData(gameManager.getData()!) { response in
                        print("Response: \(response)")
                    } errorHandler: { error in
                        print("Error \(error)")
                    }
                } else {
                    do {
                        print("Phone - updateApplicationContext()")
                        try WCSession.default.updateApplicationContext(["gameManager": gameManager.getData()!])
                    } catch {
                        print("Error sending data to watch: \(error)")
                    }
                }
            }
        }
    }
    
    @IBAction func nextHoleButtonPressed(_ sender: UIButton) {
        let didWork = gameManager.nextHole()
        if didWork{
            updateScreen()
            updateSteppers()
            updateWatch()
        }
    }
    
    @IBAction func previousHoleButtonPressed(_ sender: UIButton) {
        let didWork = gameManager.previousHole()
        if didWork {
            updateScreen()
            updateSteppers()
            updateWatch()
        } else {
            print("No previous holes!")
        }
    }
    
    @IBAction func strokesStepperPressed(_ sender: UIStepper) {
        gameManager.updateStrokesTaken(holeIndex: nil, newValue: Int(sender.value))
        updateWatch()
        updateScreen()
    }
    @IBAction func chipsStepperPressed(_ sender: UIStepper) {
        gameManager.updateChipsTaken(holeIndex: nil, newValue: Int(sender.value))
        updateWatch()
        updateScreen()
    }
    @IBAction func putsStepperPressed(_ sender: UIStepper) {
        gameManager.updatePutsTaken(holeIndex: nil, newValue: Int(sender.value))
        updateWatch()
        updateScreen()
    }
    @IBAction func penaltiesStepperPressed(_ sender: UIStepper) {
        gameManager.updatePenaltiesTaken(holeIndex: nil, newValue: Int(sender.value))
        updateWatch()
        updateScreen()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        gameManager = GameManager()
        gameManager.saveGameManager()
        updateWatch()
        updateScreen()
        updateSteppers()
    }
}

extension ViewController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("phone - activationDidCompleteWith")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("phone - sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("phone - sessionDidBecomeInactive")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("Phone - didReceiveMessageData")
        DispatchQueue.main.async {
            self.gameManager.importData(data: messageData)
            self.updateSteppers()
            self.updateScreen()
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Phone - didReceiveApplicationContext")
        DispatchQueue.main.async {
            self.gameManager.importData(data: applicationContext["gameManager"] as! Data)
            self.updateScreen()
            self.updateSteppers()
        }
        
    }
}
