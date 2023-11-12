//
//  FinishedView.swift
//  QuizWysa
//
//  Created by Yash Saxena on 11/11/23.
//

import Foundation
import UIKit
import Lottie

class FinishedView: UIViewController {
    
    var finalScore: Int = 0
    
    @IBOutlet weak var outerView: UIView!
    var questions: [QuizResponse] = []
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var innerLottieView: LottieAnimationView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkScore()
    }
    
    func setupUI() {
        scoreLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        scoreLabel.numberOfLines = 2
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        self.scoreLabel.text = ("Your Score is: \(finalScore)")
        outerView.layer.cornerRadius = 18
        contentView.backgroundColor = UIColor.black
        let animationView = LottieAnimationView(name: "Thankyou")
        animationView.contentMode = .scaleAspectFit
        animationView.center = self.innerLottieView.center
        animationView.frame = self.innerLottieView.bounds
        animationView.loopMode = .repeat(.infinity)
        animationView.play()
        self.innerLottieView.addSubview(animationView)
    }
    
    func checkScore() {
           let perfectScore = questions.count
           let passingScore = Int(Double(perfectScore) * 0.7)

           if finalScore == perfectScore {
               scoreLabel.text = "Perfect! You answered all questions correctly."
           } else if finalScore >= passingScore {
               scoreLabel.text = "Congratulations! You passed the quiz."
           } else {
               scoreLabel.text = "Keep practicing. You can do better next time."
           }
       }
    
    @IBAction func startAgainBtn(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    
}
