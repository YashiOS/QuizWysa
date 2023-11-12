//
//  QuestionsView.swift
//  QuizWysa
//
//  Created by Yash Saxena on 11/11/23.
//

import Foundation
import UIKit

class QuestionsView: UIViewController {
    @IBOutlet var answersButton: [UIButton]!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var voiceSupportLabel: UILabel!
    var questions: [QuizResponse] = []
    var currentQuestionIndex = 0
    var score = 0
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        upperView.frame.size.width = UIScreen.main.bounds.width
        upperView.layer.cornerRadius = 50
        upperView.clipsToBounds = true
        upperView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        contentView.backgroundColor = UIColor.black
        categoryLabel.text = ""
        upperView.backgroundColor = UIColor.white
        categoryLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        categoryLabel.textAlignment = .left
        backBtn.setTitle("", for: .normal)
        questionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        questionLabel.textColor = UIColor.white
        questionLabel.numberOfLines = 0
        fetchQuestions()
        
        for button in answersButton {
            button.layer.cornerRadius = 28
            button.tintColor = .white
            button.setTitle("", for: .normal)
        }
        questionLabel.text = ""
        voiceSupportLabel.text = "Voice Over Support is supported in this application.To configure VoiceOver settings, please go to Settings > Accessibility > VoiceOver."
        voiceSupportLabel.numberOfLines = 0
        voiceSupportLabel.isAccessibilityElement = true
        voiceSupportLabel.accessibilityLabel = voiceSupportLabel.text
        voiceSupportLabel.textColor = .white
        voiceSupportLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        voiceSupportLabel.textAlignment = .left
    }
    func fetchQuestions() {
            guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple") else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching questions: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Result.self, from: data)

                    self.questions = result.results ?? []

                    DispatchQueue.main.async {
                        self.displayQuestion()
                    }

                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    func animateTransitionToNextQuestion() {
            
           
        }

    func displayQuestion() {
            guard currentQuestionIndex < questions.count else {
                return
            }

            let currentQuestion = questions[currentQuestionIndex]
        if let decodedQuestion = currentQuestion.question?.decodeHTMLEntities() {
                questionLabel.text = "Q\(currentQuestionIndex + 1): \(decodedQuestion)"
            }
            

        
        categoryLabel.text = "Difficulty : \(currentQuestion.difficulty!.uppercased())"
        categoryLabel.isAccessibilityElement = true
        categoryLabel.accessibilityLabel = currentQuestion.difficulty
        questionLabel.isAccessibilityElement = true
        questionLabel.accessibilityLabel = currentQuestion.question
        print("\(currentQuestion.category)")
            if let incorrectAnswers = currentQuestion.incorrect_answers {
                let answers = (incorrectAnswers) + [currentQuestion.correct_answer ?? ""]
                for (index, button) in answersButton.enumerated() {
                    let title = answers[index]
                    button.isAccessibilityElement = true
                    button.accessibilityLabel = "\(button.currentTitle) \(index+1)"
                    if let decodedTitle = title.decodeHTMLEntities() {
                                   button.setTitle(decodedTitle, for: .normal)
                                   button.accessibilityLabel = decodedTitle
                               } else {
                                   
                                   button.setTitle(title, for: .normal)
                                   button.accessibilityLabel = title
                               }
                    let attributedTitle = NSAttributedString(
                                 string: title,
                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: button.titleLabel?.font.pointSize ?? 12.0)]
                             )
                  
                    button.setAttributedTitle(attributedTitle, for: .normal)
                }
            }
        }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(identifier: "ViewController")
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
    }
    @IBAction func answerButton(_ sender: Any) {
        guard currentQuestionIndex < questions.count else {
             return
         }
        let currentQuestion = questions[currentQuestionIndex]

        if (sender as AnyObject).tag == 0 {
            UIView.transition(with: questionLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
                
                self.currentQuestionIndex = (self.currentQuestionIndex) % self.questions.count
            }, completion: nil)
               score += 1
           }

           currentQuestionIndex += 1

           if currentQuestionIndex < questions.count {
               displayQuestion()
           } else {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let nextVC = storyboard.instantiateViewController(identifier: "FinishedView") as! FinishedView
               nextVC.modalPresentationStyle = .fullScreen
               nextVC.finalScore = self.score
               self.present(nextVC, animated: true)
           }
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "FinishedView") as! FinishedView
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.finalScore = self.score
            self.present(nextVC, animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension String {
    
        func decodeHTMLEntities() -> String? {
            guard let data = data(using: .utf8) else { return nil }
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            do {
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                return attributedString.string
            } catch {
                print("Error decoding HTML entities: \(error)")
                return nil
            }
        
    }
}
