//
//  IntentHandler.swift
//  SiriNotes_SiriExtension
//
//  Created by Steven Beyers on 6/14/17.
//  Copyright © 2017 Chariot. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
}

extension IntentHandler: INCreateNoteIntentHandling {
    
    public func handle(createNote intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Swift.Void) {
        let context = DatabaseHelper.shared.persistentContainer.viewContext
        let newNote = Note(context: context)
        newNote.title = intent.title
        newNote.details = intent.content?.description
        
        // Save the context.
        do {
            try context.save()
            
            let response = INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.success, userActivity: nil)
            response.createdNote = INNote(title: intent.title!, contents: [], groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
            
            completion(response)
        } catch {
            
            completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.failure, userActivity: nil))
        }
    }
    
    public func confirm(createNote intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Swift.Void) {
        completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.ready, userActivity: nil))
    }
    
    public func resolveTitle(forCreateNote intent: INCreateNoteIntent, with completion: @escaping (INStringResolutionResult) -> Swift.Void) {
        let result: INStringResolutionResult
        
        if let title = intent.title, title.count > 0 {
            result = INStringResolutionResult.success(with: title)
        } else {
            result = INStringResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    
    public func resolveContent(forCreateNote intent: INCreateNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Swift.Void) {
        let result: INNoteContentResolutionResult
        
        if let content = intent.content {
            result = INNoteContentResolutionResult.success(with: content)
        } else {
            result = INNoteContentResolutionResult.notRequired()
        }
        
        completion(result)
    }
    
    
    public func resolveGroupName(forCreateNote intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Swift.Void) {
        completion(INSpeakableStringResolutionResult.notRequired())
    }
    
}
