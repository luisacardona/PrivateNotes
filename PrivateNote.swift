//
//  PrivateNote.swift
//  PrivateNotes
//
//  Created by Luisa Cardona on 11/11/20.
//  Copyright © 2020 Luisa Cardona. All rights reserved.
//

import Foundation

class PrivateNote {
    private(set) var noteId        : UUID
    private(set) var noteTitle     : String
    private(set) var noteText      : String
    private(set) var noteTimeStamp : Int64
    
    init(noteTitle:String, noteText:String, noteTimeStamp:Int64) {
        self.noteId         = UUID()
        self.noteTitle      = noteTitle
        self.noteText       = noteText
        self.noteTimeStamp  = noteTimeStamp
    }
    
    init(noteId: UUID, noteTitle:String, noteText:String, noteTimeStamp:Int64) {
        self.noteId         = UUID()
        self.noteTitle      = noteTitle
        self.noteText       = noteText
        self.noteTimeStamp  = noteTimeStamp
    }
}
