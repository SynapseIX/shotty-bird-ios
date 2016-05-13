//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Alex Studnička
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  ASAttributedLabelNode.swift
//
//  Created by Alex Studnicka on 15/08/14.
//  Copyright © 2016 Alex Studnicka. MIT License.
//

import UIKit
import SpriteKit

class ASAttributedLabelNode: SKSpriteNode {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init(size: CGSize) {
		super.init(texture: nil, color: .clearColor(), size: size)
	}
	
	var attributedString: NSAttributedString! {
		didSet {
			draw()
		}
	}
	
	func draw() {
		guard let attrStr = attributedString else {
			texture = nil
			return
		}
		
		let scaleFactor = UIScreen.mainScreen().scale
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGImageAlphaInfo.PremultipliedLast.rawValue
		guard let context = CGBitmapContextCreate(nil, Int(size.width * scaleFactor), Int(size.height * scaleFactor), 8, Int(size.width * scaleFactor) * 4, colorSpace, bitmapInfo) else {
			return
		}

		CGContextScaleCTM(context, scaleFactor, scaleFactor)
		CGContextConcatCTM(context, CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
		UIGraphicsPushContext(context)
		
		let strHeight = attrStr.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, context: nil).height
		let yOffset = (size.height - strHeight) / 2.0
		attrStr.drawWithRect(CGRect(x: 0, y: yOffset, width: size.width, height: strHeight), options: .UsesLineFragmentOrigin, context: nil)
		
		if let imageRef = CGBitmapContextCreateImage(context) {
			texture = SKTexture(CGImage: imageRef)
		} else {
			texture = nil
		}
		
		UIGraphicsPopContext()
	}
	
}
