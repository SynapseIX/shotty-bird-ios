//
//  ParallaxBackground
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/12/16.
//  Copyright © 2016 Prof Apps. All rights reserved.
//

import SpriteKit

class ParallaxBackground: SKSpriteNode {
    
    var bgLayers = [String]()
    var backgrounds = [SKSpriteNode]()
    var clonedBackgrounds = [SKSpriteNode]()
    var speeds = [CGFloat]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Coder not implemented...")
    }
    
    func setUpBackgrounds(backgrounds:[String], size: CGSize, fastestSpeed: CGFloat, speedDecrease: CGFloat) {
        bgLayers = backgrounds
        
        zPosition = -1
        position = CGPointMake(size.width / 2, size.height / 2)
        
        let zPos = 1.0 / Double(backgrounds.count)
        var bgNumber = 0.0
        
        var currentSpeed = fastestSpeed
        
        var tmpBackgrounds = [SKSpriteNode]()
        var tmpClonedBackgrounds = [SKSpriteNode]()
        var tmpSpeeds = [CGFloat]()
        
        for currentBackground in backgrounds {
            let node = SKSpriteNode(imageNamed: currentBackground)
            node.zPosition = self.zPosition - CGFloat(zPos + (zPos * bgNumber))
            
            var yPos = CGFloat(0.0)
            
            if (DeviceModel.iPhone5 || DeviceModel.iPhone6 || DeviceModel.iPhone6Plus) {
                if backgrounds[0].containsString("bg1") || backgrounds[0].containsString("bg3") || backgrounds[0].containsString("bg6") {
                    yPos = 95.0
                }
                
                if backgrounds[0].containsString("bg7") {
                    yPos = -95.0
                }
            }
            
            node.position = CGPoint(x: 0.0, y: yPos)
            node.size = size
            
            let clonedNode = SKSpriteNode(imageNamed: currentBackground)
            clonedNode.zPosition = zPosition - CGFloat(zPos + (zPos * bgNumber))
            clonedNode.position = CGPoint(x: -node.size.width, y: yPos)
            clonedNode.size = size
            
            tmpBackgrounds.append(node)
            tmpClonedBackgrounds.append(clonedNode)
            tmpSpeeds.append(currentSpeed)
            
            currentSpeed = CGFloat(currentSpeed - speedDecrease)
            
            if currentSpeed < 0.0 {
                currentSpeed = 0.5
            }
            
            self.addChild(node)
            self.addChild(clonedNode)
            
            bgNumber += 1
        }
       
        if Int(bgNumber) == backgrounds.count {
            self.backgrounds = tmpBackgrounds
            self.clonedBackgrounds = tmpClonedBackgrounds
            self.speeds = tmpSpeeds
        }
    }
    
    func update(){
        for (index, currentBackground) in backgrounds.enumerate() {
            let speed = speeds[index]
            let clonedBackground = clonedBackgrounds[index]
            
            var newBackgroundX = currentBackground.position.x
            var newClonedX = clonedBackground.position.x
            
            newBackgroundX += speed
            newClonedX += speed
            
            if (newBackgroundX >= currentBackground.size.width) {
                newBackgroundX = newClonedX - (clonedBackground.size.width - 0.05)
            }
            
            if newClonedX >= clonedBackground.size.width {
                newClonedX = newBackgroundX - (currentBackground.size.width - 0.05)
            }
            
            currentBackground.position = CGPoint(x: newBackgroundX, y: currentBackground.position.y)
            clonedBackground.position = CGPoint(x: newClonedX, y: clonedBackground.position.y)
        }
    }
}
