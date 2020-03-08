//
//  GameScene.swift
//  Breathe over Coffee
//
//  Created by Simon Salomons on 08/03/2020.
//  Copyright © 2020 Smongo. All rights reserved.
//

import SpriteKit
import GameplayKit

private var red: CGFloat { 54 / 255 }
private var green: CGFloat { 1 }
private var blueMin: CGFloat { 184 / 255 }
private var blueMax: CGFloat { 248 / 255 }

private var growDuration: TimeInterval { 3 }
private var delayDuration: TimeInterval { 1 }
private var radius: CGFloat { 50 }
private var growth: CGFloat { 3 }

class GameScene: SKScene {
    
    private lazy var mainNode = SKNode()
    private var circleNodes: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        addChild(mainNode)

        let rotateAction = SKAction.rotate(byAngle: -.pi / 2, duration: growDuration)
        rotateAction.timingMode = .easeInEaseOut
        let waitAction = SKAction.wait(forDuration: delayDuration)
        let sequence = SKAction.sequence([rotateAction,
                                          waitAction,
                                          rotateAction.reversed(),
                                          waitAction])
        mainNode.run(SKAction.repeatForever(sequence))

        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3

            let wrapperNode = SKNode()
            wrapperNode.zRotation = angle + .pi / 6
            mainNode.addChild(wrapperNode)

            let circleNode = SKShapeNode(circleOfRadius: radius)
            let blue = blueMin + (blueMax - blueMin) / 2 * -sin(angle)
            circleNode.fillColor = UIColor(red: red, green: green, blue: blue, alpha: 0.15)
            circleNode.lineWidth = 0
            circleNode.blendMode = .add
            wrapperNode.addChild(circleNode)

            let translation = radius * growth * 0.95
            let moveAction = SKAction.moveBy(x: translation, y: 0, duration: growDuration)
            moveAction.timingMode = .easeInEaseOut
            let scaleAction = SKAction.scale(by: growth, duration: growDuration)
            scaleAction.timingMode = .easeInEaseOut
            let moveAndScaleAction = SKAction.group([moveAction, scaleAction])
            let sequence = SKAction.sequence([moveAndScaleAction,
                                              waitAction,
                                              moveAndScaleAction.reversed(),
                                              waitAction])
            circleNode.run(SKAction.repeatForever(sequence))

            let secondCircleNode = SKShapeNode(circleOfRadius: radius)
            secondCircleNode.fillColor = circleNode.fillColor
            secondCircleNode.lineWidth = 0
            secondCircleNode.blendMode = .add
            secondCircleNode.alpha = 0
            wrapperNode.addChild(secondCircleNode)

            let fadeInAction = SKAction.fadeIn(withDuration: growDuration)
            fadeInAction.timingMode = .easeInEaseOut
            let fadeOutAction = SKAction.fadeOut(withDuration: growDuration / 3 * 2)
            let extraWaitAction = SKAction.wait(forDuration: growDuration / 3)
            fadeOutAction.timingMode = .easeInEaseOut
            let reverseScaleAction = SKAction.scale(to: growth * 0.75, duration: growDuration / 3 * 2)
            reverseScaleAction.timingMode = .easeInEaseOut
            let reverseMoveAction = SKAction.moveTo(x: translation / 3 * 2, duration: growDuration / 3 * 2)
            reverseMoveAction.timingMode = .easeInEaseOut
            let secondGrowAction = SKAction.group([moveAction, scaleAction, fadeInAction])
            let secondShrinkAction = SKAction.group([reverseScaleAction, reverseMoveAction, fadeOutAction])
            let resetScaleAction = SKAction.run {
                secondCircleNode.setScale(1)
                secondCircleNode.position = .zero
            }
            let secondSequence = SKAction.sequence([secondGrowAction,
                                                    waitAction,
                                                    secondShrinkAction,
                                                    extraWaitAction,
                                                    waitAction,
                                                    resetScaleAction])
            secondCircleNode.run(SKAction.repeatForever(secondSequence))
        }
    }
}
