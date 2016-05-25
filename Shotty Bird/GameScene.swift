//
//  GameScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 5/5/16.
//  Copyright (c) 2016 Jorge Tapia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bgLayers = [String]()
    var parallaxBackground: ParallaxBackground?
    
    var audioManager = AudioManager(file: "gameplay_music", type: "wav", loop: true)
    var muted = false
    
    let zPositionBg = CGFloat(-1)
    let zPositionMenuItems = CGFloat(Int.max)
    
    var lastUpdateTime: CFTimeInterval = 0.0
    var lastSpawnTime: CFTimeInterval = 0.0
    var lastShotFiredTime: CFTimeInterval = 0.0
    
    var lives = 3
    var score = 0
    
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    let playWingFlapSoundAction = SKAction.playSoundFileNamed("wing_flap.wav", waitForCompletion: false)
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    let finishedMovedAction = SKAction.removeFromParent()
    
    let bird_big_fat_green = ["bird_big_fat_green_1", "bird_big_fat_green_2"]
    let bird_big_fat_yellow = ["bird_big_fat_yellow_1", "bird_big_fat_yellow_2"]
    let bird_normal_blue = ["bird_normal_blue_1", "bird_normal_blue_2"]
    let bird_normal_orange = ["bird_normal_orange_1", "bird_normal_orange_2"]
    let bird_skinny_green = ["bird_skinny_green_1", "bird_skinny_green_2"]
    let bird_skinny_red = ["bird_skinny_red_1", "bird_skinny_red_2"]
    
    // MARK: - Scene methods
    
    override func didMoveToView(view: SKView) {
        // Setup game
        setupAudioManager()
        setupGameWorld()
        
        // Setup game UI nodes
        addParallaxBackground()
        addLifeNodes()
        addScoreNode()
        addMuteButton()
    }
    
    override func willMoveFromView(view: SKView) {
        for node in children {
            node.removeFromParent()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if let pauseButton = childNodeWithName("pauseButton") as? SKSpriteNode {
                if pauseButton.containsPoint(location) {
                    togglePause()
                    return
                }
            }
            
            if let muteButton = childNodeWithName("muteButton") as? SKSpriteNode {
                if view!.paused  {
                    return
                }
                
                if muteButton.containsPoint(location) {
                    audioManager.audioPlayer?.volume = muted ? 1.0 : 0.0
                    muted = audioManager.audioPlayer?.volume == 0.0 ? true : false
                    
                    muteButton.texture = muted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
                    return
                }
            }
            
            // If paused, don't allow shooting
            if view!.paused {
                return
            }
            
            // Limit taps to shoot missiles based on current bird spawn times and last touch time
            if lastShotFiredTime == 0.0 {
                shootMissile(location)
                lastShotFiredTime = CACurrentMediaTime()
            } else {
                let deltaTime = CACurrentMediaTime() - lastShotFiredTime
                
                if deltaTime >= lastSpawnTime * 0.5 {
                    shootMissile(location)
                    lastShotFiredTime = CACurrentMediaTime()
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        var timeSinceLast = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
        }
        
        lastSpawnTime += timeSinceLast
        
        parallaxBackground?.update()
        
        switch score {
        case 0...10:
            if lastSpawnTime > 2.2 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 11...20:
            if lastSpawnTime > 2.0 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 21...25:
            if lastSpawnTime > 1.8 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 26...35:
            if lastSpawnTime > 1.6 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 36...40:
            if lastSpawnTime > 1.4 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 41...45:
            if lastSpawnTime > 1.35 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 46...50:
            if lastSpawnTime > 1.30 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 51...55:
            if lastSpawnTime > 1.25 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 56...60:
            if lastSpawnTime > 1.20 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 61...65:
            if lastSpawnTime > 1.15 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 66...70:
            if lastSpawnTime > 1.10 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 71...80:
            if lastSpawnTime > 1.05 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 81...90:
            if lastSpawnTime > 1.0 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 91...100:
            if lastSpawnTime > 0.9 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 101...110:
            if lastSpawnTime > 0.8 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        case 111...120:
            if lastSpawnTime > 0.75 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        default:
            if lastSpawnTime > 0.7 {
                lastSpawnTime = 0.0
                spawnBird()
            }
        }
    }
    
    // MARK: - User interface methods
    
    private func addParallaxBackground() {
        parallaxBackground = ParallaxBackground(texture: nil, color: UIColor.clearColor(), size: size)
        parallaxBackground?.setUpBackgrounds(bgLayers, size: size, fastestSpeed: 14.0, speedDecrease: 4.2)
        addChild(parallaxBackground!)
    }
    
    private func addLifeNodes() {
        // Add first life node
        let firstLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height - 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height / 2 - 20)
        } else {
            firstLife.position = CGPoint(x: CGRectGetMinX(frame) + firstLife.size.width / 2 + 20, y: CGRectGetMaxY(frame) - firstLife.size.height * 2)
        }
        
        firstLife.name = "life1"
        firstLife.zPosition = zPositionMenuItems
        addChild(firstLife)
        
        // Add second life node
        let secondLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height - 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height / 2 - 20)
        } else {
            secondLife.position = CGPoint(x: CGRectGetMinX(frame) + secondLife.size.width * 2 - 10, y: CGRectGetMaxY(frame) - secondLife.size.height * 2)
        }
        
        secondLife.name = "life2"
        secondLife.zPosition = zPositionMenuItems
        addChild(secondLife)
        
        // Add third life node
        let thirdLife = SKSpriteNode(imageNamed: "life")
        
        if DeviceModel.iPhone4 {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height - 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height / 2 - 20)
        } else {
            thirdLife.position = CGPoint(x: CGRectGetMinX(frame) + thirdLife.size.width * 3 - 5, y: CGRectGetMaxY(frame) - thirdLife.size.height * 2)
        }
        
        thirdLife.name = "life3"
        thirdLife.zPosition = zPositionMenuItems
        addChild(thirdLife)
    }
    
    private func addScoreNode() {
        let scoreLabel = ASAttributedLabelNode(size: CGSize(width: 165.0, height: 65.0))
        
        if let font =  UIFont(name: "Kenney-Bold", size: 35) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .Right
            
            let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.whiteColor(),
                              NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -10, NSParagraphStyleAttributeName: paragraphStyle]
            
            scoreLabel.attributedString = NSAttributedString(string: "0", attributes: attributes)
            scoreLabel.zPosition = zPositionMenuItems
            scoreLabel.name = "score"
        }
        
        if DeviceModel.iPad || DeviceModel.iPadPro {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - scoreLabel.size.width / 2 - 10, y: CGRectGetMaxY(frame) - scoreLabel.size.height / 2 - 10)
        } else if DeviceModel.iPhone4 {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - scoreLabel.size.width / 2 - 10, y: CGRectGetMaxY(frame) - scoreLabel.size.height - 20)
        } else {
            scoreLabel.position = CGPoint(x: CGRectGetMaxX(frame) - scoreLabel.size.width / 2 - 10, y: CGRectGetMaxY(frame) - scoreLabel.size.height * 2 - 10)
        }
        
        addChild(scoreLabel)
    }
    
    private func addPauseButton() {
        let pauseButton = SKSpriteNode(imageNamed: "pause_button")
        pauseButton.position = CGPoint(x: CGRectGetMinX(frame) + pauseButton.size.width - 20, y: CGRectGetMinY(frame) + pauseButton.size.height * 2)
        
        if DeviceModel.iPhone4 {
            pauseButton.position = CGPoint(x: CGRectGetMinX(frame) + pauseButton.size.width - 20, y: CGRectGetMinY(frame) + pauseButton.size.height + 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            pauseButton.position = CGPoint(x: CGRectGetMinX(frame) + pauseButton.size.width - 20, y: CGRectGetMinY(frame) + pauseButton.size.height - 20)
        } else {
            pauseButton.position = CGPoint(x: CGRectGetMinX(frame) + pauseButton.size.width - 20, y: CGRectGetMinY(frame) + pauseButton.size.height * 2)
        }
        
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = zPositionMenuItems
        addChild(pauseButton)
    }
    
    private func addMuteButton() {
        let muteButton = muted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        
        if DeviceModel.iPhone4 {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + 20)
        } else if DeviceModel.iPad || DeviceModel.iPadPro {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 20)
        } else {
            muteButton.position = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height * 2)
        }
        
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    private func getGameOverScene() -> GameOverScene {
        // This is the "default" scene frame size provided by SpriteKit: print(scene.size)
        let scene = GameOverScene(size: CGSize(width: 1024.0, height: 768.0))
        scene.muted = muted
        scene.bgLayers = bgLayers
        scene.score = score
        scene.scaleMode = .AspectFill
        
        return scene
    }
    
    // MARK: - Audio methods
    
    private func setupAudioManager() {
        audioManager.audioPlayer?.volume = !muted ? 1.0 : 0.0
        audioManager.audioPlayer?.enableRate = true
        audioManager.tryPlayMusic()
    }
    
    // MARK: - Game world methods
    
    private func setupGameWorld() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    // MARK: - Shooting methods
    
    private func shootMissile(location: CGPoint) {
        let missile = Missile(delegate: self)
        missile.position = location
        
        // Setup missile's Physics
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.size)
        missile.physicsBody?.dynamic = false
        missile.physicsBody?.restitution = 0.0
        missile.physicsBody?.collisionBitMask = PhysicsCategory.Missile
        
        if !muted {
            missile.runAction(playShotSoundAction)
        }

        addChild(missile)
    }
    
    // MARK: - Spawn methods
    
    private func spawnBird() {
        let birds = [bird_big_fat_green, bird_big_fat_yellow, bird_normal_blue, bird_normal_orange, bird_skinny_green, bird_skinny_red]
        let sprites = birds[Int(arc4random_uniform(UInt32(birds.count)))]
        
        let newBird = Bird(sprites: sprites, delegate: self)
        
        // Calculate bird's depth position and scaling
        let zPosBird = CGFloat(arc4random_uniform(5))
        newBird.zPosition = zPosBird
        
        switch zPosBird {
        case 4:
            newBird.setScale(0.2)
        case 3:
            newBird.setScale(0.175)
        case 2:
            newBird.setScale(0.15)
        case 1:
            newBird.setScale(0.135)
        case 0:
            newBird.setScale(0.1)
        default:
            break
        }
        
        let minY = DeviceModel.iPad || DeviceModel.iPadPro || DeviceModel.iPhone4 ? newBird.size.height + 20 : newBird.size.height + 70
        let maxY = DeviceModel.iPad || DeviceModel.iPadPro || DeviceModel.iPhone4 ? frame.height - minY - 20 : frame.height - minY - 50
        let rangeY = maxY - minY
        let birdY = (CGFloat(arc4random()) % rangeY) + minY
        
        newBird.position = CGPoint(x: frame.width + (newBird.size.width / 2), y: birdY)
        addChild(newBird)
        
        // Setup bird node Physics
        newBird.physicsBody = SKPhysicsBody(rectangleOfSize: newBird.size)
        newBird.physicsBody?.dynamic = false
        newBird.physicsBody?.restitution = 1.0
        newBird.physicsBody?.collisionBitMask = PhysicsCategory.Bird
        
        // Setup actions
        let minDuration = 3.00
        let maxDuration = 6.00
        let rangeDuration = maxDuration - minDuration
        let actualDuration = (Double(arc4random()) % rangeDuration) + minDuration
        
        // Store bird speed
        newBird.flightSpeed = actualDuration
        
        let flapAction = SKAction.animateWithTextures([SKTexture(imageNamed: newBird.sprites[0]), SKTexture(imageNamed: newBird.sprites[1])], timePerFrame: 0.1)
        let flyAction = SKAction.repeatAction(flapAction, count: Int(actualDuration / 0.2))
        let moveAction = SKAction.moveTo(CGPoint(x: -newBird.size.width / 2, y: newBird.position.y), duration: actualDuration)
        let flyAndMoveAction = SKAction.group([flyAction, moveAction])
        
        let sequence = muted ? SKAction.sequence([flyAndMoveAction, finishedMovedAction]) : SKAction.sequence([playWingFlapSoundAction, flyAndMoveAction, playBirdSoundAction, finishedMovedAction])
        
        // Runs action sequence and executes completion closure to determine if a bird escaped
        newBird.runAction(sequence) {
            if newBird.position == CGPoint(x: -newBird.size.width / 2, y: newBird.position.y) {
                self.lives -= 1
                
                if self.lives == 2 {
                    let node = self.childNodeWithName("life1") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                } else if self.lives == 1 {
                    let node = self.childNodeWithName("life2") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                } else if self.lives == 0 {
                    let node = self.childNodeWithName("life3") as! SKSpriteNode
                    node.texture = SKTexture(imageNamed: "death")
                    
                    // Present game over scene
                    self.audioManager.stopMusic()
                    let transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                    self.view?.presentScene(self.getGameOverScene(), transition: transition)
                }
            }
        }
    }
    
    // MARK: - Pause methods
    
    func togglePause() {
        if !view!.paused {
            let pauseButton = childNodeWithName("pauseButton") as! SKSpriteNode
            pauseButton.texture = SKTexture(imageNamed: "play_button_icon")
            audioManager.audioPlayer?.pause()
            
            // Delay pause by 0.05 seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.view?.paused = true
            }
        } else {
            let pauseButton = self.childNodeWithName("pauseButton") as! SKSpriteNode
            pauseButton.texture = SKTexture(imageNamed: "pause_button")
            audioManager.audioPlayer?.play()
            
            // Delay unpause by 0.05 seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.view?.paused = false
            }
        }
    }
}

// MARK: - Game score delegate

extension GameScene: GameScoreDelegate {
    
    func updateScore() {
        score += 1
        
        // Increment music playback rate based on player score
        switch score {
        case 10:
            audioManager.audioPlayer?.rate = 1.05
        case 20:
            audioManager.audioPlayer?.rate = 1.15
        case 30:
            audioManager.audioPlayer?.rate = 1.25
        case 50:
            audioManager.audioPlayer?.rate = 1.35
        case 60:
            audioManager.audioPlayer?.rate = 1.45
        case 70:
            audioManager.audioPlayer?.rate = 1.55
        case 80:
            audioManager.audioPlayer?.rate = 1.65
        case 90:
            audioManager.audioPlayer?.rate = 1.75
        case 100:
            audioManager.audioPlayer?.rate = 1.80
        case 110:
            audioManager.audioPlayer?.rate = 1.90
        case 120:
            audioManager.audioPlayer?.rate = 2.00
        default:
            break
        }
        
        // Update score label with new score
        if let node = childNodeWithName("score") as? ASAttributedLabelNode {
            if let font =  UIFont(name: "Kenney-Bold", size: 35) {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .Right
                
                let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.whiteColor(),
                                  NSStrokeColorAttributeName: UIColor.blackColor(), NSStrokeWidthAttributeName: -10, NSParagraphStyleAttributeName: paragraphStyle]
                
                node.attributedString = NSAttributedString(string: "\(score)", attributes: attributes)
            }
        }
    }
    
}

// MARK: - Physics contact delegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Handle missile - bird collision
        if firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Missile {
            print("Hit a bird with a missile...")
        }
    }
    
}
