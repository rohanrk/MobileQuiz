//
//  QuestionDownloader.swift
//  MobileQuiz
//
//  Created by Rohan Rk on 10/24/18.
//  Copyright © 2018 Rohan Rk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
struct QuestionDownloader {
    
    static func download(completion: @escaping ([Question]?, Error?) -> Void) {
        let baseurl = "https://opentdb.com/api.php?amount=4&category=9&difficulty=medium&type=multiple"
        Alamofire.request(baseurl).responseJSON { response in
            switch response.result {
            case .success:
                let data = JSON(response.result.value!)
                var trivia: [Question] = []
                for (_, value) in data["results"] {
                    trivia.append(Question(question: value["question"].stringValue, correct: value["correct_answer"].stringValue, incorrect: value["incorrect_answers"].arrayValue.map({$0.stringValue}), type: value["type"].stringValue))
                }
                completion(trivia, nil)
            case .failure(let error):
                completion(nil, error)
                
            }
        }
        
    }
}
