//
//  Model.swift
//  EYAZIIS2
//
//  Created by Rakhmatov Beymamat on 8.12.23.
//

import Foundation
import PDFKit
import NaturalLanguage

class Model {
    
    let fileURL1 = URL(fileURLWithPath: "/Users/rakhmatovbeymamat/Documents/EYZIIS/EYAZIIS(2)/texts/Russian.pdf")
    let fileURL2 = URL(fileURLWithPath: "/Users/rakhmatovbeymamat/Documents/EYZIIS/EYAZIIS(2)/texts/English.pdf")
    lazy var fileURLs = [fileURL1, fileURL2]
    
    func loadTextFromPDF(url: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: url) else {
            return nil
        }

        var text = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                if let pageText = page.string {
                    text += pageText
                }
            }
        }

        return text
    }

    func createLanguageModels() -> [String: [Character: Double]] {
        var languageModels = [String: [Character: Double]]()
        
        for fileURL in fileURLs {
            if let text = loadTextFromPDF(url: fileURL) {
                let language = fileURL.lastPathComponent
                let characterFrequency = calculateCharacterFrequency(text: text)
                languageModels[language] = characterFrequency
            }
        }
        
        return languageModels
    }

    func calculateCharacterFrequency(text: String) -> [Character: Double] {
        var characterCount = [Character: Int]()
        var totalCharacters = 0
        
        for char in text {
            if char.isASCII {
                if let count = characterCount[char] {
                    characterCount[char] = count + 1
                } else {
                    characterCount[char] = 1
                }
                
                totalCharacters += 1
            }
        }
        
        var characterFrequency = [Character: Double]()
        
        for (char, count) in characterCount {
            let frequency = Double(count) / Double(totalCharacters)
            characterFrequency[char] = frequency
        }
        
        return characterFrequency
    }
    
    func detectLanguageByShortWords(userText: String, shortWords: [String: [String]]) -> String? {
        let userWords = Set(userText.components(separatedBy: .whitespacesAndNewlines))

        for (language, words) in shortWords {
            let intersection = Set(words).intersection(userWords)
            if intersection.count > 0 {
                return language
            }
        }

        return nil
    }

    func detectLanguage(userText: String, languageModels: [String: [Character: Double]]) -> String? {
        let userCharacterFrequency = calculateCharacterFrequency(text: userText)
        
        var bestMatchLanguage: String?
        var bestMatchDistance = Double.greatestFiniteMagnitude
        
        for (language, languageModel) in languageModels {
            var distance = 0.0
            
            for (char, frequency) in userCharacterFrequency {
                let modelFrequency = languageModel[char] ?? 0.0
                distance += abs(frequency - modelFrequency)
            }
            
            if distance < bestMatchDistance {
                bestMatchDistance = distance
                bestMatchLanguage = language
            }
        }
        print(bestMatchDistance)
        return bestMatchLanguage
    }
    
    func detectLanguageNL(text: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else {
            return nil
        }
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forLanguageCode: languageCode)
    }
}










