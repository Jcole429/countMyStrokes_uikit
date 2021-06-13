//
//  ViewController.swift
//  StrokeCounter
//
//  Created by Justin Cole on 6/12/21.
//

import UIKit

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
    
    
    var game = Game(holes: [Hole(holeNumber: 1, par: nil)])
    var currentHole = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScreen(holeIndex: currentHole)
    }
    
    func updateScreen(holeIndex: Int) {
        let hole = game.holes[holeIndex]
        holeNumLabel.text = "Hole #: \(hole.holeNumber)"
        totalStrokesLabel.text = "Total Strokes: \(hole.totalStrokesTaken)"
        strokesLabel.text = "Strokes: \(hole.strokesTaken)"
        chipsLabel.text = "Chips: \(hole.chipsTaken)"
        putsLabel.text = "Puts: \(hole.putsTaken)"
        penaltiesLabel.text = "Penalties: \(hole.penaltiesTaken)"
        
        totalScoreLabel.text = "Total Score: \(game.totalScore)"
    }
    
    func updateSteppers() {
        strokesStepper.value = Double(game.holes[currentHole].strokesTaken)
        chipsStepper.value = Double(game.holes[currentHole].chipsTaken)
        putsStepper.value = Double(game.holes[currentHole].putsTaken)
        penaltiesStepper.value = Double(game.holes[currentHole].penaltiesTaken)
    }
    
    @IBAction func nextHoleButtonPressed(_ sender: UIButton) {
        if currentHole < 17 {
            currentHole += 1
            if game.holes.count <= currentHole {
                game.holes.append(Hole(holeNumber: currentHole + 1, par: nil))
            }
            updateScreen(holeIndex: currentHole)
            updateSteppers()
        }
    }
    
    @IBAction func previousHoleButtonPressed(_ sender: UIButton) {
        if currentHole > 0 {
            currentHole -= 1
            updateScreen(holeIndex: currentHole)
            updateSteppers()
        } else {
            print("No previous holes!")
        }
    }
    
    @IBAction func strokesStepperPressed(_ sender: UIStepper) {
        game.holes[currentHole].strokesTaken = Int(sender.value)
        updateScreen(holeIndex: currentHole)
    }
    @IBAction func chipsStepperPressed(_ sender: UIStepper) {
        game.holes[currentHole].chipsTaken = Int(sender.value)
        updateScreen(holeIndex: currentHole)
    }
    @IBAction func putsStepperPressed(_ sender: UIStepper) {
        game.holes[currentHole].putsTaken = Int(sender.value)
        updateScreen(holeIndex: currentHole)
    }
    @IBAction func penaltiesStepperPRessed(_ sender: UIStepper) {
        game.holes[currentHole].penaltiesTaken = Int(sender.value)
        updateScreen(holeIndex: currentHole)
    }
}

