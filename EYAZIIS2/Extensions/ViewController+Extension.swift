//
//  ViewController+Extension.swift
//  EYAZIIS2
//
//  Created by Rakhmatov Beymamat on 9.12.23.
//

import UIKit

extension ViewController: UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Обработка события изменения текста
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Обработка события нажатия клавиши Return на клавиатуре
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
