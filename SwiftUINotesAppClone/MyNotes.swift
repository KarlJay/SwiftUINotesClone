//  MyNotes.swift
//  MyNotes
//  Created by Karl Jay on 9/28/21.
import Foundation

class MyNotes: ObservableObject {
    @Published var folders = [Folder]()
}

struct Folder: Identifiable {
    var id = UUID()
    
    var name: String
    var notes: [Note] = testNotes
}

struct Note: Identifiable {
    var id = UUID()
    var title: String
    var noteText: String = ""
}

var testFolders = [

    Folder(name: "Folder 01"),
    Folder(name: "Folder 02")
]

var testNotes = [
    Note(title: "Notes1"),
    Note(title: "Notes2")
]
