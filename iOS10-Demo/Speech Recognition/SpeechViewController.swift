//
//  SpeechViewController.swift
//  iOS10-Demo
//
//  Created by Tetsuro Mikami on 10/16/16.
//  Copyright © 2016 Tetsuro Mikami. All rights reserved.
//

import UIKit
import Speech

final class SpeechViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    
    var task: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Speech Recognition"
        
        button.isEnabled = false
        
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("authorized")
                    self.button.isEnabled = true
                case .denied:
                    print("denied")
                case .restricted:
                    print("restricted")
                case .notDetermined:
                    print("not determined")
                }
                print(status)
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if task == nil {
            startRecognizeWithFile()
            button.isEnabled = false
            button.setTitle("Recognizing...", for: .normal)
        }
    }
    
    private func startRecognizeWithFile() {
        guard let audioURL = R.file.speechMp3() else {
            print("Could not get file URL!")
            return
        }
        let request = SFSpeechURLRecognitionRequest(url: audioURL)
        task = recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                print("Error on recognition task: \(error)")
                self.didFinishRecognition()
                return
            }
            self.textView.text = result.bestTranscription.formattedString
            
            if result.isFinal {
                self.didFinishRecognition()
            }
        }
    }
    
    private func didFinishRecognition() {
        button.isEnabled = true
        button.setTitle("Start Recognition", for: .normal)
        task = nil
    }
}
