// ===================================================================================================
// Copyright © 2021 bold360(Genesys).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import Foundation

class TranscriptHandler: NSObject {
    private let filepath = Bundle.main.path(forResource: "transcript", ofType: "txt")!
    
    var transcript: String! {
        get {
            var transcriptStr = ""
            do {
                transcriptStr = try String(contentsOfFile: self.filepath, encoding: .utf8)
            } catch {/* error handling here */}
            
            return transcriptStr
        }
    }
    
    func addMessage(_ text: String!) {
        do {
            try text.write(toFile: self.filepath, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    
    func donlwoadTranscript() -> String {
       return Bundle.main.path(forResource: "input", ofType: "txt")!
    }
}
