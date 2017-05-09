//
//  ProgressBarView.swift
//  DeFuge
//
//  Created by Mhatre, Aniket on 5/6/17.
//  Copyright © 2017 Mhatre, Aniket. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var progressMessageLabel: UILabel!
    @IBOutlet weak var leftStepsStackView: UIStackView!
    @IBOutlet weak var rightStepsStackView: UIStackView!
    
    private var steps = [UIImageView]()
    private var animationStartIndex = 0
    var max: Int! {
        didSet {
            progressMessageLabel.text = "\(max!) steps left"
        }
    }
    var progress: Int = 0 {
        didSet {
            var stepsLeft = max! - progress
            if stepsLeft < 0 {
                stepsLeft = 0
            }
            progressMessageLabel.text = "\(stepsLeft) steps left"
            animateSteps()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    private func initSubViews() {
        // standard initialization logic
        let nib = UINib(nibName: "ProgressBarView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        // custom initialization logic
        let leftSteps = leftStepsStackView.subviews
        let rightSteps = rightStepsStackView.subviews
        let totalStepCount = leftSteps.count + rightSteps.count
        
        for indx in 0..<totalStepCount {
            let stackIndex = indx / 2
            let stepImageView: UIImageView
            
            if (indx % 2) == 0 {
                stepImageView = leftSteps[stackIndex] as! UIImageView
            } else {
                stepImageView = rightSteps[stackIndex] as! UIImageView
            }
            
            stepImageView.alpha = 0.0
            steps.append(stepImageView)
        }
    }
    
    private func animateSteps() {
        let progressInSteps = Double(progress * steps.count) / Double(max!)
        let opaqueStepCount = floor(progressInSteps)
        var animationDelay = 0.0
        
        if animationStartIndex < steps.count  && animationStartIndex < Int(opaqueStepCount) {
            var opaqueEndIndex = Int(opaqueStepCount) - 1
            
            if opaqueEndIndex >= steps.count {
                opaqueEndIndex = steps.count - 1
            }

            for index in animationStartIndex...opaqueEndIndex {
                let stepView = steps[index]
                
                UIView.animate(withDuration: 2.0, delay: animationDelay, options: [], animations: {
                    stepView.alpha = 1.0
                }, completion: nil)
                
                animationDelay += 0.5
            }
            
            var newStartIndex = opaqueEndIndex + 1
            
            let lastAnimationStepAlpha = progressInSteps - opaqueStepCount
            
            if (lastAnimationStepAlpha > 0 && newStartIndex < steps.count) {
                let stepView = steps[Int(opaqueStepCount)]
                
                UIView.animate(withDuration: 2.0, delay: animationDelay, options: [], animations: {
                    stepView.alpha = 1.0
                }, completion: nil)
                
                newStartIndex += 1
            }
            
            animationStartIndex = newStartIndex
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
