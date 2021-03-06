//
//  Hole.swift
//  CountMyStrokes
//
//  Created by Justin Cole on 6/13/21.
//

import Foundation

struct Hole: Codable {
    var holeNumber: Int
    var par: Int?
    var totalStrokesTaken: Int {
        get {
            return strokesTaken + chipsTaken + putsTaken + penaltiesTaken
        }
    }
    var strokesTaken = 0
    var chipsTaken = 0
    var putsTaken = 0
    var penaltiesTaken = 0
}
