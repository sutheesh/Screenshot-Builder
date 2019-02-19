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
    
    var selectedImage: NSImage?
    var selectedBgImage: NSImage?
    var captionColor:NSColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        userCaptionInput.delegate = self
        allViews.isHidden = true
        imagePicker.color = .black
    }
    
    func catchImageiPhoneX() -> NSView {
        let imageSize = CGSize(width: 1242, height: 2688)
        let imageView = NSImageView(frame: NSRect(origin: .zero, size: imageSize))
        imageView.image = selectedBgImage
        imageView.imageScaling = .scaleAxesIndependently
        
        let textView = NSView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.wantsLayer = true
        
        imageView.addSubview(textView)
        textView.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 50).isActive = true
        textView.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -50).isActive = true
        textView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 100).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
       
        let label = NSTextField()
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        label.alignment = .center
        label.sizeToFit()
        label.textColor = captionColor ?? .black
        label.stringValue = yourCaptionLabel.stringValue
        label.font = NSFont(name: "KohinoorTelugu-Medium", size: 80)
        textView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: 0).isActive = true

        let userSelectedImage = NSImageView(frame: NSRect(x: 120, y: -150, width: 1002, height: 2688))
        userSelectedImage.image = selectedImage
        userSelectedImage.imageScaling = .scaleProportionallyUpOrDown
        imageView.addSubview(userSelectedImage)
        
        let iPhoneXImageView = NSImageView(frame: NSRect(x: 50, y: -150, width: 1142, height: 2688))
        iPhoneXImageView.image = NSImage(named: "iPhoneX-black")
        iPhoneXImageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.addSubview(iPhoneXImageView)
     
        
        return imageView
    }

    @IBAction func resetAll(_ sender: Any) {
        selectedImage = nil
        selectedImageView.image = nil
        allViews.isHidden = true
        dragView.layer?.backgroundColor = NSColor.blue.cgColor


    }
    
    @IBAction func downloadSave(_ sender: Any) {
        let imageSize = CGSize(width: 1242, height: 2688)
        saveFolderSelection { (url) in
            if self.catchImageiPhoneX().snapshot.resizedImageTo(newSize: imageSize)?.savePNG(to: url) ?? false {
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
