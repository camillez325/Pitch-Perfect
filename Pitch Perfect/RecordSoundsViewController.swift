//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Egorio on 1/15/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetRecorderScreenState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
    func resetRecorderScreenState() {
        stopButton.isHidden = true
        pauseButton.isHidden = true
        recordButton.isEnabled = true
        recordingInProgress.text = "Tap to record your voice"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(recorder: recorder)
            
            performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
        else {
            resetRecorderScreenState()
            
            recordingInProgress.text = "Something wrong, try to Record again"
        }
    }
    
    @IBAction func startRecordingAudio(_ sender: UIButton) {
        recordingInProgress.text = "Recording..."
        recordButton.isEnabled = false
        pauseButton.isHidden = false
        pauseButton.isEnabled = true
        stopButton.isHidden = false
        
        let session = AVAudioSession.sharedInstance()
        
        if session.category != AVAudioSessionCategoryPlayAndRecord {
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! session.setActive(true)
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string:pathArray.joined(separator: "/"))
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordingAudio(_ sender: UIButton) {
        recordingInProgress.text = "Tap to continue recording"
        pauseButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecorder.pause()
    }
    
    @IBAction func stopRecordingAudio(_ sender: UIButton) {
        pauseButton.isHidden = true
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}
