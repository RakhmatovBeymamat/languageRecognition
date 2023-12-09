//
//  ViewController.swift
//  EYAZIIS2
//
//  Created by Rakhmatov Beymamat on 8.12.23.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    var model = Model()
    
    var textView: UITextView!
    var languageSegmentedControl: UISegmentedControl!
    let resultLabel = UILabel()
    
//    // Загружаем текст из двух файлов PDF
//    let fileURL1 = URL(fileURLWithPath: "/Users/rakhmatovbeymamat/Documents/EYZIIS/EYAZIIS(2)/texts/Russian.pdf")
//    let fileURL2 = URL(fileURLWithPath: "/Users/rakhmatovbeymamat/Documents/EYZIIS/EYAZIIS(2)/texts/English.pdf")
//    var fileURLs = [URL]()
    
    var languageModels = [String: [Character: Double]]()
    let shortWords: [String: [String]] = [
        "english": ["a", "an", "the", "is", "are"],
        "russian": ["и", "в", "на", "с", "о"],
        // Добавьте короткие слова для других языков
    ]
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fileURLs = [fileURL1, fileURL2]
        languageModels = model.createLanguageModels()
        
        view.backgroundColor = .systemBackground
        self.title = "Определить язык"
        
        aboutBtn()
        addResultLabel()
        addButton()
        addSegment()
        addTextView()
    }
    
    @objc func btnTapped() {
        let selectedSegmentIndex = languageSegmentedControl.selectedSegmentIndex
        guard let textViewText = textView.text else {return}
        
        switch selectedSegmentIndex {
        case 0:
            if !textViewText.isEmpty {
                if let detectedLanguage = model.detectLanguage(userText: textViewText, languageModels: languageModels) {
                    if detectedLanguage == "English.pdf" {
                        resultLabel.text = "Определенный язык(частотный): Английский"
                    } else {
                        resultLabel.text = "Определенный язык(частотный): Русский"
                    }

                } else {
                    resultLabel.text = "Не удалось определить язык"
                }
            } else {
                resultLabel.text = "Текстовое поле пустое"
            }
            
        case 1:
            if !textViewText.isEmpty {
                if let detectedLanguage = model.detectLanguageByShortWords(userText: textViewText, shortWords: shortWords) {
                    if detectedLanguage == "english" {
                        resultLabel.text = "Определенный язык(коротких): Английский"
                    } else {
                        resultLabel.text = "Определенный язык(коротких): Русский"
                    }
                } else {
                    resultLabel.text = "Не удалось определить язык"
                }
            } else {
                resultLabel.text = "Текстовое поле пустое"
            }
            
        case 2:
            if !textViewText.isEmpty {
                if let detectedLanguage = model.detectLanguageNL(text: textViewText) {
                    resultLabel.text = "Определенный язык(нейросетевой): \(detectedLanguage)"
                } else {
                    resultLabel.text = "Не удалось определить язык"
                }
            } else {
                resultLabel.text = "Текстовое поле пустое"
            }
            
        default:
            break

        }
        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {}
    
    @objc func about() {
        let vc = AboutViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = .init(width: 500, height: 500)  // the size of popover
        vc.popoverPresentationController?.sourceView = self.view    // the view of the popover
        vc.popoverPresentationController?.sourceRect = CGRect(    // the place to display the popover
            origin: CGPoint(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY
            ),
            size: .zero
        )
        vc.popoverPresentationController?.permittedArrowDirections = [] // the direction of the arrow
        vc.popoverPresentationController?.delegate = self               // delegate
        navigationController?.present(vc, animated: true)
    }
    
    func aboutBtn() {
        let aboutButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"),
                                         style: .done,
                                         target: self,
                                         action: #selector(about))
        self.navigationItem.leftBarButtonItem = aboutButton
    }

    func addResultLabel() {
        resultLabel.frame = CGRect(x: 20, y: self.view.bounds.height - 100, width: self.view.bounds.width - 40, height: 50)
        resultLabel.textAlignment = .center
        resultLabel.textColor = .black
        resultLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(resultLabel)
    }
    
    func addButton() {
        let buttonWidth: CGFloat = screenWidth - 20
        let buttonHeight: CGFloat = 50
        let buttonX = (screenWidth - buttonWidth) / 2
        let buttonY = ((screenHeight * 0.6) + 180)

        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.titleLabel?.text = "Определить"
        button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        button.setTitle("Нажмите", for: .normal)
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        // Добавьте кнопку на вашу иерархию представлений, например, на вашу view
        self.view.addSubview(button)
    }
    
    func addSegment() {
        // Создаем UISegmentedControl
        let segmentItems = ["Частотный", "Коротких слов", "Нейросетевой"]
        languageSegmentedControl = UISegmentedControl(items: segmentItems)
        
        let segmentedControlWidth = screenWidth - 20
        let segmentedControlHeight: CGFloat = 30
        let segmentedControlX = (screenWidth - segmentedControlWidth) / 2
        let segmentedControlY = ((screenHeight * 0.6) + segmentedControlHeight + 100)
        
        languageSegmentedControl.frame = CGRect(x: segmentedControlX, y: segmentedControlY, width: segmentedControlWidth, height: segmentedControlHeight)
        languageSegmentedControl.selectedSegmentIndex = 0 // Устанавливаем выбранный сегмент
        languageSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        view.addSubview(languageSegmentedControl)
    }
    
    func addTextView() {
        // Создаем текстовое поле
        textView = UITextView(frame: CGRect(x: 10, y: 100, width: screenWidth - 20, height: screenHeight * 0.6))
        textView.layer.cornerRadius = 18
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .secondarySystemBackground
        textView.delegate = self // Устанавливаем делегат для обработки событий текстового поля
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        view.addSubview(textView)
        
    }

}




//"Привет! Как твои дела? Надеюсь, у тебя все хорошо. Я хотел бы рассказать тебе о своей последней поездке. Я отправился в путешествие по России и посетил множество удивительных мест. Первой остановкой был Санкт-Петербург, где я посетил Эрмитаж и насладился прекрасной архитектурой города. Затем я отправился в Москву, где увидел Красную площадь и Кремль. Величественные здания и исторические памятники оставили на меня глубокое впечатление. После этого я побывал в Сочи, где наслаждался красивыми пляжами и замечательным климатом. В общем, моя поездка была незабываемой. Я очень рад, что смог увидеть и насладиться всей этой красотой."

//Hello! How are you doing? I hope you're doing well. I would like to tell you about my recent trip. I went on a journey across Russia and visited many amazing places. The first stop was St. Petersburg, where I visited the Hermitage Museum and enjoyed the beautiful architecture of the city. Then I went to Moscow, where I saw the Red Square and the Kremlin. The magnificent buildings and historical monuments left a deep impression on me. After that, I visited Sochi, where I enjoyed the beautiful beaches and wonderful climate. Overall, my trip was unforgettable. I'm really glad that I had the opportunity to see and experience all this beauty.
