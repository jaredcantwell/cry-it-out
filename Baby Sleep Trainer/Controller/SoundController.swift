//
//  SoundController.swift
//  Baby Sleep Trainer
//
//  Created by Kenny on 5/29/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit
import AVFoundation


class SoundController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordBtn: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBAction func recordBaby(_ sender: UIButton) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //removing text from Storyboard - text exists on storyboard solely to make label more visible
        errorLbl.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        //do-try block used to check for recording permission
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {  allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //start recording
                        print("recording allowed")
                    } else {
                        self.errorLbl.text = "Recording Permission was Denied. Please open settings and allow Cry It Out to access the microphone."
                    }
                }
            }
        } catch {
            print("recording disallowed")
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("baby.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordBtn.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordBtn.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordBtn.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
}

