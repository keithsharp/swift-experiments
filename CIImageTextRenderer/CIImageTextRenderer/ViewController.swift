//
//  ViewController.swift
//  CIImageTextRenderer
//
//  Created by Keith Sharp on 03/07/2021.
//

import Cocoa
import CoreImage.CIFilterBuiltins

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ciContext = CIContext()
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : NSColor.red]
        let string = NSAttributedString(string: "Hello, World!", attributes: attributedStringColor)
        
        let textImageGenerator = CIFilter.attributedTextImageGenerator()
        textImageGenerator.text = string
        textImageGenerator.scaleFactor = 2.0
        
        guard let textImage = textImageGenerator.outputImage else {
            fatalError("Failed to create the text CIIMage.")
        }
        
        guard let cgImage = ciContext.createCGImage(textImage, from: textImage.extent) else {
            fatalError("Failed to get CGImage for CIImage.")
        }
        imageView.image = NSImage(cgImage: cgImage, size: .zero)
    }

}

