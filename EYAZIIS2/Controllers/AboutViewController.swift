//
//  AboutViewController.swift
//  EYAZIIS2
//
//  Created by Rakhmatov Beymamat on 8.12.23.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addAboutText()
        addDoneBtn()
        view.backgroundColor = .systemBackground
    }
    
    private func addAboutText() {
        let textView = UITextView()
        textView.text = """
        Это приложение для удобного определения языка! Здесь вы можете легко определить в каком языке написан ваш текст.
        
        Нажмите кнопку с восклицательным знаком, чтобы получить подсказки по использованию.
        
        Вставьте или введите свой текст, который хотите проверить на каком языке он написан.
        
        У вас есть возможность выбрать метод определения языка, в частности "Частотный", Коротких слов" и "Нейросетевой".
        
        Нажмите на кнопку внизу с надписью "Определить", чтобы узнать на каком языке написан язык.

        """
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = true
        textView.frame = CGRect(x: 20, y: 50, width: view.frame.width - 40, height: 500)
        view.addSubview(textView)
    }
    
    private func addDoneBtn() {
        let doneBtn = UIBarButtonItem(title: "Готово",
                                      image: nil,
                                      target: self,
                                      action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBtn
    }
    
    @objc func done() {
        
    }
}
