//
//  ViewController.swift
//  StrokeCounter
//
//  Created by Justin Cole on 6/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var totalStrokesLabel: UILabel!
    @IBOutlet weak var holeNumLabel: UILabel!
    @IBOutlet weak var strokesLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var putsLabel: UILabel!
    @IBOutlet weak var penaltiesLabel: UILabel!
    
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
    }
    
    @IBAction func nextHoleButtonPressed(_ sender: UIButton) {
        if currentHole < 17 {
            currentHole += 1
            if game.holes.count <= currentHole {
                game.holes.append(Hole(holeNumber: currentHole + 1, par: nil))
            }
            updateScreen(holeIndex: currentHole)
        }
    }
    
    @IBAction func previousHoleButtonPressed(_ sender: UIButton) {
        if currentHole > 0 {
            currentHole -= 1
            updateScreen(holeIndex: currentHole)
        } else {
            print("No previous holes!")
        }
    }
}

