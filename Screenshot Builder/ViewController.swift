//
//  ViewController.swift
//  Screenshot Builder
//
//  Created by Sutheesh Sukumaran on 2/16/19.
//  Copyright © 2019 iLabbs. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var dragView: DropView!
    @IBOutlet weak var selectedImageView: NSImageView!
    @IBOutlet weak var bgImageView: NSImageView!
    @IBOutlet weak var allViews: NSView!
    @IBOutlet weak var yourCaptionLabel: NSTextField!
    @IBOutlet weak var userCaptionInput: NSTextField!
    @IBOutlet weak var imagePicker: NSColorWell!
    @IBOutlet weak var convertableView: NSView!
    @IBOutlet weak var isPhone8: NSSwitch!
    @IBOutlet weak var skeltonImageView: NSImageView!
    @IBOutlet weak var selectedImageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var selectedImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var selectedImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var selectedImageViewBottom: NSLayoutConstraint!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var selectedImage: NSImage?
    var selectedBgImage: NSImage?
    var captionColor:NSColor?
    var savedImageHeight = 2688
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        userCaptionInput.delegate = self
        allViews.isHidden = true
        imagePicker.color = .black
        isPhone8.state = .on
    }
    

    @IBAction func resetAll(_ sender: Any) {
        selectedImage = nil
        selectedImageView.image = nil
        allViews.isHidden = true
        dragView.layer?.backgroundColor = NSColor.blue.cgColor


    }
    
    @IBAction func downloadSave(_ sender: Any) {
        let imageSize = CGSize(width: 1242, height: savedImageHeight)
        saveFolderSelection { (url) in
            if self.convertableView.snapshot.resizedImageTo(newSize: imageSize)?.savePNG(to: url) ?? false {
                ScreenshotHelper().dialogOKCancel(question: "Saved Successfully", text: "Your Screenshot has been successfully saved!.")
            }
        }
    }
    
    @IBAction func bgImageSelect(_ sender: Any) {
        
        openFolderSelection { (url) in
            self.selectedBgImage = NSImage(contentsOf: url)
            self.bgImageView.image = self.selectedBgImage
        }
    }
    
    
    @IBAction func changeColor(_ sender : NSColorWell)
    {
        captionColor = sender.color
        yourCaptionLabel.textColor = captionColor
    }
    
    @IBAction func iPhone8(_ sender: Any) {
        if isPhone8.state == .on {
            skeltonImageView.image = NSImage(named: "iPhone8Plus-black")
            selectedImageViewTop.constant = 54
            selectedImageViewBottom.constant = 54
            imageHeightConstraint.constant = 552
            savedImageHeight = 2208

        }else {
            skeltonImageView.image = NSImage(named: "iPhoneX-black")
            imageHeightConstraint.constant = 672
            selectedImageViewTop.constant = 15
            selectedImageViewBottom.constant = 15
            savedImageHeight = 2688
        }
        
        resetAll(sender)
    }
    
}

extension ViewController: DragViewDelegate {
    func dragView(didDragFileWith imageUrl: String) {
        selectedImage = NSImage(contentsOf: URL(fileURLWithPath: imageUrl))
        selectedImageView.image = selectedImage
        allViews.isHidden = false
        
    }
    
}

extension NSView {
    func getImage() -> NSImage? {
        let dataOfView = self.dataWithPDF(inside: self.bounds)
        return NSImage(data: dataOfView)
    }
    var snapshot: NSImage {
        guard let bitmapRep = bitmapImageRepForCachingDisplay(in: bounds) else { return NSImage() }
        cacheDisplay(in: bounds, to: bitmapRep)
        let image = NSImage()
        image.addRepresentation(bitmapRep)
        return image
    }
}


extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}

extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}

extension NSImage {
    var png: Data? {
        return tiffRepresentation?.bitmap?.png
    }
    func savePNG(to url: URL) -> Bool {
        do {
            try png?.write(to: url)
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    func compressImage(factor: Float = 0.5) -> NSImage {
        let imageRep = NSBitmapImageRep(data: self.tiffRepresentation ?? Data())
        let options = NSDictionary(object: NSNumber(value: factor), forKey: NSBitmapImageRep.PropertyKey.compressionFactor as NSCopying)
        let compressedData = imageRep?.representation(using: .jpeg, properties: options as! [NSBitmapImageRep.PropertyKey : Any])
        return NSImage(data: compressedData ?? Data()) ?? NSImage()
    }
    
    func resizedImageTo(newSize: NSSize) -> NSImage?{
        
        if self.isValid == false {
            
            return nil
            
        }
        
        guard let representation = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else { return self }
        
        representation.size = newSize
        
        
        
        NSGraphicsContext.saveGraphicsState()
        
        NSGraphicsContext.current = NSGraphicsContext.init(bitmapImageRep: representation)
        
        self.draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: NSZeroRect, operation: .copy, fraction: 1.0)
        
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newSize)
        newImage.addRepresentation(representation)
        return newImage
    }
}


extension ViewController {
    
    func saveFolderSelection(callback: @escaping (URL)->Void)
    {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["png","jpg"]
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = "Screenshot"
        savePanel.allowsOtherFileTypes = true
        
        savePanel.begin
            { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue
                {
                    let url = savePanel.url
                    callback(url!)
                }
        }
    }
    
    func openFolderSelection(callback: @escaping (URL)->Void)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin
            { (result) -> Void in
                if result.rawValue == NSApplication.ModalResponse.OK.rawValue
                {
                    let url = openPanel.url
                    callback(url!)
                }
        }
    }
    
}


extension ViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ notification: Notification)
    {
        let object = notification.object as! NSTextField
        self.yourCaptionLabel.stringValue = object.stringValue
    }
}
