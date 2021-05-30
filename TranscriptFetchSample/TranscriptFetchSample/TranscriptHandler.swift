// ===================================================================================================
// Copyright © 2021 bold360(Genesys).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import Foundation

class TranscriptHandler: NSObject {
    private let filepath = Bundle.main.path(forResource: "transcript", ofType: "txt")!
    private var transcriptStr = ""
    
    var transcript: String! {
        get {
            do {
                self.transcriptStr = try String(contentsOfFile: self.filepath, encoding: .utf8)
            } catch {/* error handling here */}
            
            return transcriptStr
        }
    }
    
    func addMessage(_ text: String!) {
        do {
            self.transcriptStr = self.transcriptStr + "\n" + text;
            try self.transcriptStr.write(toFile: self.filepath, atomically: false, encoding: .utf8)
        }
        catch {/* error handling here */}
    }
    
    func donlwoadTranscript() -> String {
       return Bundle.main.path(forResource: "input", ofType: "txt")!
    }
}
