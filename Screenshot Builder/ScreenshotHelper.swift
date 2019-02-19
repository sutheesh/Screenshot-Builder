//
//  ScreenshotHelper.swift
//  Screenshot Builder
//
//  Created by Sutheesh Sukumaran on 2/18/19.
//  Copyright © 2019 iLabbs. All rights reserved.
//

import Foundation
import Cocoa
class ScreenshotHelper {
    
    func dialogOKCancel(question: String, text: String, showCancel: Bool = false) {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        if showCancel {
            alert.addButton(withTitle: "Cancel")
        }
        
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
        }
    }
    
}
