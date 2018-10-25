//
//  QuizViewController.swift
//  MobileQuiz
//
//  Created by Rohan Rk on 10/24/18.
//  Copyright © 2018 Rohan Rk. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var trivia: [Question] = []
    var score: Int = 0
    var currentq: Question?
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scoreLabel.text = "Score: \(score)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        QuestionDownloader.download(completion: { data, error in
            if let _ = error {
                print(error!)
            } else if let questions = data {
                self.trivia = questions
                self.addQuestionToView(q: self.trivia.popLast()!)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addQuestionToView(q: Question) {
        currentq = q
        question.text = q.question
        optionA.setTitle(q.correct, for: .normal)
        optionB.setTitle(q.incorrect[0], for: .normal)
        optionC.setTitle(q.incorrect[1], for: .normal)
        optionD.setTitle(q.incorrect[2], for: .normal)
        
    }
    
    func endQuiz() {
        if score == 40 {
            print("You win!")
        } else {
            let alert = UIAlertController(title: "You lost!", message: "Better Luck Next Time!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkStatus() {
        if trivia.isEmpty {
            endQuiz()
        } else {
            addQuestionToView(q: trivia.popLast()!)
        }
    }
    
    @IBAction func verifyAnswer(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if button.titleLabel?.text == currentq?.correct {
            score += 10
            let alert = UIAlertController(title: "Correct Answer!", message: "You earned 10 points!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yay!", style: .default, handler: { _ in
                self.checkStatus()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Wrong Answer!", message: "The correct answer was \(currentq!.correct)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.checkStatus()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
