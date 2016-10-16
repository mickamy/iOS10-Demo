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
    
    var request: SFSpeechRecognitionRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Speech Recognition"
        
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized: break
                // The user authorized your app's request to perform speech recognition.
            case .denied: break
                // The user denied your app's request to perform speech recognition.
            case .restricted: break
                // The authorization status of your app's request to perform speech recognition is unknown.
            case .notDetermined: break
                // The device denies your app's request to perform speech recognition.
            }
            print(status)
        }
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        startRecognizeWithFile()
    }
    
    private func startRecognizeWithFile() {
        guard let audioURL = R.file.speechMp3() else {
            print("Could not get file URL!")
            return
        }
        request = SFSpeechURLRecognitionRequest(url: audioURL)
        recognizer?.recognitionTask(with: request!) { result, error in
            guard let result = result else {
                print("Error on recognition task: \(error)")
                return
            }
            self.textView.text = result.bestTranscription.formattedString
        }
    }
}
