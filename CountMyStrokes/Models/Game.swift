//
//  Game.swift
//  StrokeCounter
//
//  Created by Justin Cole on 6/13/21.
//

import Foundation

struct Game: Codable {
    var totalScore: Int {
        get {
            var sum = 0
            for hole in holes {
                sum += hole.totalStrokesTaken
            }
            return sum
        }
    }
    var holes: [Hole]
}
