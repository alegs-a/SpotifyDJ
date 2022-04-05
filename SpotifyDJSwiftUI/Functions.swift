//
//  Functions.swift
//  SpotifyDJSwiftUI
//
//  Created by Alex Arthur on 30/3/2022.
//

import Foundation

func millisToMinsSecs(milliseconds: Int) -> String {
    let totalSeconds: Int = milliseconds/1000 // implicitly returns Int
    let totalMinutes: Int = totalSeconds/60
    if totalMinutes == 0 { // Catches division by 0 error in `totalSeconds%totalMinutes`
        var output = "\(totalMinutes):"
        if String(totalSeconds).count == 1 {
            output += "0\(totalSeconds)"
        } else {
            output += String(totalSeconds)
        }
        return output
    } // Implicit 'else' since if clause returns
        let remainderSeconds: Int = totalSeconds%6
        var output = "\(totalMinutes):"
        if String(remainderSeconds).count == 1 {
            output += "0\(remainderSeconds)"
        } else {
            output += String(remainderSeconds)
        }
        return output
}

func move<T>(from source: IndexSet, to destination: Int, array: inout [T])  {
    array.move(fromOffsets: source, toOffset: destination)
}

func doNothing() { }
