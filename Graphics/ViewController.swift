//
//  ViewController.swift
//  Graphics
//
//  Created by Robin Malhotra on 13/02/17.
//  Copyright © 2017 Robin Malhotra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	func image(from str: String, with width: CGFloat, height: CGFloat, font: UIFont) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
		let img = renderer.image { ctx in
			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 0.0
			paragraphStyle.alignment = .center
			
			let attrs = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle]
			
			let attrString = NSAttributedString(string: str, attributes: attrs)
			let rect = attrString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics], context: nil)
			let string = str
			let diffs = ((width - rect.width)/2.0, (height - rect.height)/2.0)
			let centeredRect = CGRect(x: diffs.0, y: diffs.1, width: rect.width, height: rect.height)
			string.draw(with: centeredRect, options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics], attributes: attrs, context: nil)
		}
		return img
	}
	
	func generateAvatarStrings() -> [String] {
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters.flatMap { $0.description }
		
		let generated = alphabet * alphabet
		return generated
	}
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		for str in generateAvatarStrings() {
			let imageName = str
			
			let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
			let fURL = dir.appendingPathComponent(imageName, isDirectory: false).appendingPathExtension("png")
			let font = UIFont.systemFont(ofSize: 295, weight: UIFontWeightBold)
			let img = image(from: imageName, with: 512, height: 512, font: font)
			let data = UIImagePNGRepresentation(img)!
			
			do {
				if !FileManager.default.fileExists(atPath: fURL.absoluteString) {
					let createdFile = FileManager.default.createFile(atPath: fURL.absoluteString, contents: data)
					NSLog("File created? \(createdFile)")
				}
				
				try "The other string!".write(to: fURL, atomically: true, encoding: .utf8)
				
				if !FileManager.default.fileExists(atPath: fURL.absoluteString) {
					let createdFile = FileManager.default.createFile(atPath: fURL.absoluteString, contents: data, attributes: nil)
					NSLog("File created? \(createdFile)")
				}
				print(fURL)
				try data.write(to: fURL)
			} catch {
				NSLog(error.localizedDescription)
			}
			
		}
		
		
		
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


func *(xs: [String], ys: [String]) -> [String] {
	return xs.reduce([]) { result, x in
		return result + ys.reduce([]) {
			return $0 + [x + $1]
		}
	}
}

