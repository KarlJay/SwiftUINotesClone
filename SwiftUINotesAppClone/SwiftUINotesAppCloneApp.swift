//
//  SwiftUINotesAppCloneApp.swift
//  SwiftUINotesAppClone
//
//  Created by Karl Jay on 9/27/21.
//

import SwiftUI

@main
struct SwiftUINotesAppCloneApp: App {
    // @9:40
    @StateObject private var myNotes = MyNotes()
    
    var body: some Scene {
        WindowGroup {
            ContentView(myNotes: myNotes)
        }
    }
}
