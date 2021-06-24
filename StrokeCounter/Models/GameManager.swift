//
//  GameManager.swift
//  StrokeCounter
//
//  Created by Justin Cole on 6/22/21.
//

import Foundation

class GameManager: Codable {
    static let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Games.plist")
    
    var game = Game(holes: [Hole(holeNumber: 1, par: nil)])
    var currentHoleIndex = 0
    
    
    func getCurrentHole() -> Hole {
        return game.holes[currentHoleIndex]
    }
    
    func updateStrokesTaken(holeIndex: Int?, newValue: Int) {
        if let index = holeIndex {
            game.holes[index].strokesTaken = newValue
        } else {
            game.holes[currentHoleIndex].strokesTaken = newValue
        }
    }
    
    func updateChipsTaken(holeIndex: Int?, newValue: Int) {
        if let index = holeIndex {
            game.holes[index].chipsTaken = newValue
        } else {
            game.holes[currentHoleIndex].chipsTaken = newValue
        }
    }
    
    func updatePutsTaken(holeIndex: Int?, newValue: Int) {
        if let index = holeIndex {
            game.holes[index].putsTaken = newValue
        } else {
            game.holes[currentHoleIndex].putsTaken = newValue
        }
    }
    
    func updatePenaltiesTaken(holeIndex: Int?, newValue: Int) {
        if let index = holeIndex {
            game.holes[index].penaltiesTaken = newValue
        } else {
            game.holes[currentHoleIndex].penaltiesTaken = newValue
        }
    }
    
    func saveGameManager() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self)
            try data.write(to: GameManager.dataFilePath!)
            print("encoded gameManager")
        } catch {
            print("Error encoding gameManager, \(error)")
        }
    }
    
    func loadGameManager() {
        if let data = try? Data(contentsOf: GameManager.dataFilePath!) {
            importData(data: data)
        }
    }
    
    func getData() -> Data? {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            return nil
        }
    }
    
    func importData(data: Data) {
        let decoder = PropertyListDecoder()
        do {
            let updatedGameManager = try decoder.decode(GameManager.self, from: data)
            self.game = updatedGameManager.game
            self.currentHoleIndex = updatedGameManager.currentHoleIndex
        } catch {
             print("Error decoding gameManager, \(error)")
        }
    }
}
