//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Egorio on 1/18/16.
//  Copyright © 2016 Egorio. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
    }
    
    func stopPlaying() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func playWithRate(_ rate: Float) {
        stopPlaying()
        
        let session = AVAudioSession.sharedInstance()
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playWithEffect(_ effect: AVAudioUnit) {
        stopPlaying()
        
        let session = AVAudioSession.sharedInstance()
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playWithPitch(_ pitch: Float) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = pitch
        
        playWithEffect(effect)
    }
    
    func playWithReverb() {
        let effect = AVAudioUnitReverb()
        
        playWithEffect(effect)
    }
    
    func playWithEcho() {
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.5
        effect.feedback = 30
        
        playWithEffect(effect)
    }
    
    @IBAction func playSlow(_ sender: UIButton) {
        playWithRate(0.5)
    }
    
    @IBAction func playFast(_ sender: UIButton) {
        playWithRate(1.5)
    }
    
    @IBAction func playChipmunk(_ sender: UIButton) {
        playWithPitch(1000)
    }
    
    @IBAction func playDarth(_ sender: UIButton) {
        playWithPitch(-1000)
    }
    
    @IBAction func playEcho(_ sender: UIButton) {
        playWithEcho()
    }
    
    @IBAction func playReverb(_ sender: UIButton) {
        playWithReverb()
    }
    
    @IBAction func stopPlaying(_ sender: UIButton) {
        stopPlaying()
    }
}
