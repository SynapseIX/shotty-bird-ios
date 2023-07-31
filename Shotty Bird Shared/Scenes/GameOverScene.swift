//
//  GameOverScene.swift
//  Shotty Bird
//
//  Created by Jorge Tapia on 7/27/23.
//  Copyright © 2023 Komodo Life. All rights reserved.
//

import GameKit
import SpriteKit

/// Game over scene.
class GameOverScene: BaseScene {
    
    /// The score that was obtained by the player
    let score: Int
    
    /// The game mode that was played.
    let mode: GameMode
    
    /// Audio manager to play background music.
    let audioManager = AudioManager.shared
    
    /// The z-axis position for all menu UI elements.
    let zPositionMenuItems = CGFloat(Int.max)
    
    /// Plays a bird sound clip.
    let playBirdSoundAction = SKAction.playSoundFileNamed("bird.wav", waitForCompletion: false)
    /// Plays a shot audio clip.
    let playShotSoundAction = SKAction.playSoundFileNamed("shot", waitForCompletion: false)
    /// Plays an explosion sound clip.
    let playExplosionSoundAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    /// Plays a gmae over chime sound.
    let playGameOverChime = SKAction.playSoundFileNamed("game_over_positive", waitForCompletion: false)
    
    /// Creates a new Game Over scene instance.
    /// - Parameter score: The score that was obtained.
    /// - Parameter mode: The game mode that was played.
    init(score: Int, mode: GameMode) {
        self.score = score
        self.mode = mode
        super.init(backgroundSpeed: .slow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupUI()
        audioManager.playMusic(type: .gameOver, loop: true)
        if !audioManager.isMuted {
            run(playGameOverChime)
        }
        reportAchievements()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    // MARK: - UI configuration
    
    /// Sets up all UI elements on the menu scene.
    private func setupUI() {
        // Add score panel
        let panel = SKSpriteNode(imageNamed: "score_panel")
        panel.xScale = 0.8
        panel.yScale = 0.6
        panel.zPosition = zPositionMenuItems
        panel.zPosition = zPositionMenuItems - 0.01
        panel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(panel)
        
        // Add score label
        let scoreLabel = AttributedLabelNode(size: panel.size)
        scoreLabel.zPosition = zPositionMenuItems
        scoreLabel.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMidY(panel.frame))
        guard let font =  UIFont(name: "Kenney-Bold", size: 80) else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.font : font,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeColor: UIColor.black,
                                                         .strokeWidth: -10,
                                                         .paragraphStyle: paragraphStyle]
        scoreLabel.attributedString = NSAttributedString(string: "\(score)", attributes: attributes)
        addChild(scoreLabel)
        
        // Add best score label
        let bestScoreLabel = SKLabelNode()
        bestScoreLabel.fontName = "Kenney-Bold"
        bestScoreLabel.fontSize = 17.0
        bestScoreLabel.fontColor = SKColor(red: 205.0 / 255.0, green: 164.0 / 255.0, blue: 0.0, alpha: 1.0)
        bestScoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(panel.frame) + 20)
        bestScoreLabel.zPosition = zPositionMenuItems
        
        if score == 0 {
            bestScoreLabel.text = Constants.scored0
        } else {
            let gameCenterHelper = GameCenterHelper.shared
            let leaderboardID = mode == .slayer ? Constants.slayerLeaderboardID : Constants.timeAttackLeaderboardID
            let leaderboard = gameCenterHelper.getLeaderboard(with: leaderboardID)
            leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSMakeRange(1, 1)) { entry, entries, totalPlayerCount, error in
                guard let entry = entry else {
                    return
                }
                let bestScore = entry.score
                DispatchQueue.main.async {
                    if self.score > bestScore {
                        bestScoreLabel.text = Constants.newRecord
                        gameCenterHelper.submitScore(self.score, for: self.mode) { success in
                            print("Score submitted: \(success)")
                        }
                    } else {
                        bestScoreLabel.text = String(format: Constants.yourBestScoreFormat, bestScore)
                    }
                }
            }
        }
        addChild(bestScoreLabel)
        
        // Add game over node
        let gameOver = AttributedLabelNode(size: CGSize(width: frame.size.width, height: 160))
        gameOver.name = "gameOver"
        gameOver.setScale(0.8)
        gameOver.zPosition = zPositionMenuItems
        gameOver.position = CGPoint(x: CGRectGetMidX(frame), y: panel.position.y + gameOver.size.height + 40)
        gameOver.attributedString = NSAttributedString(string: "Game Over", attributes: attributes)
        addChild(gameOver)
        
        // Add leaderboard button
        let leaderboardButton = SKSpriteNode(imageNamed: "leaderboard_button_icon")
        leaderboardButton.position = CGPoint(x: CGRectGetMidX(panel.frame), y: CGRectGetMinY(panel.frame) - leaderboardButton.size.height / 2 - 10)
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.zPosition = zPositionMenuItems
        addChild(leaderboardButton)
        
        // Add replay button
        let playButton = SKSpriteNode(imageNamed: "replay_button")
        playButton.position = CGPoint(x: leaderboardButton.position.x - playButton.size.width - 20, y: leaderboardButton.position.y)
        playButton.name = "playButton"
        playButton.zPosition = zPositionMenuItems
        addChild(playButton)

        // Add share button
        let shareButton = SKSpriteNode(imageNamed: "share_button")
        shareButton.position = CGPoint(x: leaderboardButton.position.x + playButton.size.width + 20, y: leaderboardButton.position.y)
        shareButton.name = "shareButton"
        shareButton.zPosition = zPositionMenuItems
        addChild(shareButton)
        
        // Add back button
        let backButton = SKSpriteNode(imageNamed: "back_button")
        var backButtonPosition: CGPoint = .zero
        if DeviceModel.iPad || DeviceModel.iPadPro {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height - 20)
        } else if DeviceModel.iPhoneSE {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height - 10)
        } else {
            backButtonPosition = CGPoint(x: CGRectGetMinX(frame) + backButton.size.width / 2 + 20, y: CGRectGetMinY(frame) + backButton.size.height + 20)
        }
        backButton.position = backButtonPosition
        backButton.name = "backButton"
        backButton.zPosition = zPositionMenuItems
        addChild(backButton)
        
        // Add mute button
        let muteButton = audioManager.isMuted ? SKSpriteNode(imageNamed: "mute_button") : SKSpriteNode(imageNamed: "unmute_button")
        var muteButtonPosition: CGPoint = .zero
        if DeviceModel.iPad || DeviceModel.iPadPro {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 20)
        } else if DeviceModel.iPhoneSE {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height - 10)
        } else {
            muteButtonPosition = CGPoint(x: CGRectGetMaxX(frame) - muteButton.size.width / 2 - 20, y: CGRectGetMinY(frame) + muteButton.size.height + 20)
        }
        muteButton.position = muteButtonPosition
        muteButton.name = "muteButton"
        muteButton.zPosition = zPositionMenuItems
        addChild(muteButton)
    }
    
    // MARK: - UI event handlers
    
    /// Handles the slayer button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleReplayButton(in location: CGPoint) {
        guard let playButton = childNode(withName: "playButton") else {
            return
        }
        if playButton.contains(location) {
            audioManager.stop()
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            
            let gameScene = GameScene(mode: mode)
            let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    /// Handles the leaderboard button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleGameCenterButton(in location: CGPoint) {
        guard let leaderboardButton = childNode(withName: "leaderboardButton") else {
            return
        }
        if leaderboardButton.contains(location) && GameCenterHelper.shared.isGameCenterEnabled {
            if !audioManager.isMuted {
                run(playExplosionSoundAction)
            }
            GameCenterHelper.shared.presentLeaderboard(for: mode)
        }
    }
    
    /// Handles the share button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleShareButton(in location: CGPoint) {
        guard let shareButton = childNode(withName: "shareButton") as? SKSpriteNode,
              let gameViewController = view?.window?.rootViewController as? GameViewController else {
            return
        }
        if shareButton.contains(location) {
            guard let screenshot = takeScreenshot() else {
                return
            }
            
            var convertedOrigin = convertPoint(toView: shareButton.frame.origin)
            convertedOrigin.y = convertedOrigin.y - shareButton.frame.size.height / 2
            let shareFrame = CGRect(origin: convertedOrigin, size: shareButton.frame.size)
            
            let scoreShareFormat = mode == .slayer ? Constants.shareSlayerScoreText : Constants.shareTimeAttackScoreText
            let scoreShareText = String(format: scoreShareFormat, score)
            let activityItems: [Any] = [scoreShareText, screenshot]
            let excludedActivityTypes: [UIActivity.ActivityType] = [.print,
                                                                    .copyToPasteboard,
                                                                    .assignToContact,
                                                                    .saveToCameraRoll,
                                                                    .addToReadingList,
                                                                    .airDrop,
                                                                    .openInIBooks,
                                                                    .postToVimeo,
                                                                    .collaborationCopyLink,
                                                                    .collaborationInviteWithLink,
                                                                    .markupAsPDF,
                                                                    .sharePlay]
            
            let shareController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            shareController.excludedActivityTypes = excludedActivityTypes
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = shareFrame
            shareController.popoverPresentationController?.permittedArrowDirections = [.down]
            gameViewController.present(shareController, animated: true)
        }
    }
    
    /// Handles the back button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleBackButton(in location: CGPoint) {
        guard let backButton = childNode(withName: "backButton") as? SKSpriteNode else {
            return
        }
        if backButton.contains(location) {
            if !audioManager.isMuted {
                backButton.run(playBirdSoundAction)
            }
            
            let mainMenuScene = MainMenuScene()
            let transition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
            view?.presentScene(mainMenuScene, transition: transition)
            audioManager.playMusic(type: .menu, loop: true)
        }
    }
    
    /// Handles the mute button tap event.
    /// - Parameter location: A point where the screen is tapped.
    private func handleMuteButton(in location: CGPoint) {
        guard let muteButton = childNode(withName: "muteButton") as? SKSpriteNode else {
            return
        }
        if muteButton.contains(location) {
            audioManager.isMuted.toggle()
            muteButton.texture = audioManager.isMuted ? SKTexture(imageNamed: "mute_button") : SKTexture(imageNamed: "unmute_button")
        }
    }
}

// MARK: - Touch-based event handling

extension GameOverScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            // Handle replay button tap
            handleReplayButton(in: location)
            // Handle Game Center button tap
            handleGameCenterButton(in: location)
            // Handle share button tap
            handleShareButton(in: location)
            // Handle back button tap
            handleBackButton(in: location)
            // Handle mute button tap
            handleMuteButton(in: location)
        }
    }
}

// MARK: Achievement reporting

extension GameOverScene {
    /// Reports progress for all achievements in Slayer mode.
    private func reportAchievements() {
        if mode == .slayer {
            let gameCenterHelper = GameCenterHelper.shared
            for achievement in gameCenterHelper.achievements {
                switch achievement.identifier {
                case Constants.x0:
                    gameCenterHelper.reportAchievement(identifier: Constants.x0, percentComplete: 100, showsCompletionBanner: true)
                case Constants.x50:
                    gameCenterHelper.reportAchievement(identifier: Constants.x50, percentComplete: Double(score * 100 / 50), showsCompletionBanner: true)
                case Constants.x100:
                    gameCenterHelper.reportAchievement(identifier: Constants.x100, percentComplete: Double(score * 100 / 100), showsCompletionBanner: true)
                case Constants.x150:
                    gameCenterHelper.reportAchievement(identifier: Constants.x150, percentComplete: Double(score * 100 / 150), showsCompletionBanner: true)
                case Constants.x200:
                    gameCenterHelper.reportAchievement(identifier: Constants.x200, percentComplete: Double(score * 100 / 200), showsCompletionBanner: true)
                case Constants.x250:
                    gameCenterHelper.reportAchievement(identifier: Constants.x250, percentComplete: Double(score * 100 / 250), showsCompletionBanner: true)
                case Constants.x300:
                    gameCenterHelper.reportAchievement(identifier: Constants.x300, percentComplete: Double(score * 100 / 300), showsCompletionBanner: true)
                case Constants.x500:
                    gameCenterHelper.reportAchievement(identifier: Constants.x500, percentComplete: Double(score * 100 / 500), showsCompletionBanner: true)
                default:
                    break
                }
            }
        }
    }
}

// MARK: - Social sharing

extension GameOverScene {
    // TODO: hide banner view
    private func takeScreenshot() -> UIImage? {
        guard let gameViewController = view?.window?.rootViewController as? GameViewController else {
            return nil
        }
        // gameViewController.bannerView.hidden = true
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
        view?.drawHierarchy(in: frame, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //gameViewController.bannerView.hidden = false
        return screenshot
    }
}

