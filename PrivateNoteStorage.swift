//
//  NoteStorage.swift
//  PrivateNotes
//
//  Created by Luisa Cardona on 12/3/20.
//  Copyright © 2020 Luisa Cardona. All rights reserved.
//

import CoreData

class PrivateNoteStorage {
    static let storage : PrivateNoteStorage = PrivateNoteStorage()
    
    private var noteIndexToIdDict : [Int:UUID] = [:]
    private var currentIndex : Int = 0

    private(set) var managedObjectContext : NSManagedObjectContext
    private var managedContextHasBeenSet : Bool = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = PrivateNoteCoreDataHelper.readNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = PrivateNoteCoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
    
    func addNote(noteToBeAdded: PrivateNote) {
        if managedContextHasBeenSet {
            // add note UUID to the dictionary
            noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
            PrivateNoteCoreDataHelper.createNoteInCoreData(
                noteToBeCreated:          noteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
            // increase index
            currentIndex += 1
        }
    }
    
    func removeNote(at: Int) {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            PrivateNoteCoreDataHelper.deleteNoteFromCoreData(
                noteIdToBeDeleted:        noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            // update noteIndexToIdDict dictionary
            // the element we removed was not the last one: update GUID's
            if (at < currentIndex - 1) {
                // currentIndex - 1 is the index of the last element
                // but we will remove the last element, so the loop goes only
                // until the index of the element before the last element
                // which is currentIndex - 2
                for i in at ... currentIndex - 2 {
                    noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                }
            }
            // remove the last element
            noteIndexToIdDict.removeValue(forKey: currentIndex)
            // decrease current index
            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> PrivateNote? {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return nil
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            let noteReadFromCoreData: PrivateNote?
            noteReadFromCoreData = PrivateNoteCoreDataHelper.readNoteFromCoreData(
                noteIdToBeRead:           noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    func changeNote(noteToBeChanged: PrivateNote) {
        if managedContextHasBeenSet {
            // check if UUID is in the dictionary
            var noteToBeChangedIndex : Int?
            noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                PrivateNoteCoreDataHelper.changeNoteInCoreData(
                noteToBeChanged: noteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
                // TODO error handling
            }
        }
    }

    
    func count() -> Int {
        return PrivateNoteCoreDataHelper.count
    }
}
