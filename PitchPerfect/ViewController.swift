//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Camille Zhang on 6/26/17.
//  Copyright © 2017 Camille Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var RecordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    //called before view class gets loaded to memory
    //will gets called before did
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(_ sender: Any)
    {
        print("button pressed")
        RecordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
    }
    @IBAction func StopRecording(_ sender: Any) {
        print("stopped")
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        RecordingLabel.text = "Tap to Record"
    }

}

