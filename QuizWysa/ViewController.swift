//
//  ViewController.swift
//  QuizWysa
//
//  Created by Yash Saxena on 11/11/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var innerLottieView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var playNowButton: UIButton!
    @IBOutlet var contentViw: UIView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var playNowLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    
    func setupUI() {
        playNowLabel.text = "Let's Play!"
        playNowLabel.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        playNowLabel.textAlignment = .center
        playNowLabel.textColor = UIColor.white
        winLabel.text = "Play Now & Win"
        winLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        winLabel.textAlignment = .center
        winLabel.textColor = UIColor.green
        contentViw.backgroundColor = UIColor.black
        playNowButton.tintColor = .white
        playNowButton.layer.cornerRadius = 18
        outerView.layer.cornerRadius = 15
        outerView.layer.shadowRadius = 10
        animation()
    }
    
    private func animation() {
        let animationView = LottieAnimationView(name: "Welcome")
        animationView.contentMode = .scaleAspectFit
        animationView.center = self.innerLottieView.center
        animationView.frame = self.innerLottieView.bounds
        animationView.loopMode = .repeat(.infinity)
        animationView.play()
        self.innerLottieView.addSubview(animationView)
    }
    @IBAction func playNowBtn(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(identifier: "QuestionsView")
        nextVC.modalPresentationStyle = .fullScreen
        QuestionsView().displayQuestion()
        self.present(nextVC, animated: true)
        
    }
    

}

