//
//  Words.swift
//  MacEng
//
//  Created by Даниил Харенков on 28.05.2020.
//  Copyright © 2020 Даниил Харенков. All rights reserved.
//

import Foundation

struct Word {
    var rus: String
    var eng: String
}

class Words {
    public static func getRandomWord() -> Word{
        if let path = Bundle.main.path(forResource: "words", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let words = jsonResult["words"] as? [Any] {
                    let randomIndex = Int.random(in: 0..<words.count) //Гененрируем случайный индекс
                    let word = words[randomIndex] as! [String: String]
                    let en = word["en"]!
                    let ru = word["ru"]!
                    return Word(rus: ru, eng: en)
                }
            } catch {
                print(error)
                return Word(rus: "Ошибка", eng: "Error")
            }
        }
        
        return Word(rus: "Ошибка", eng: "Error")
    }
}
