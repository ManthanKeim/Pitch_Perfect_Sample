//
//  RecordSoundsViewCeontroller.swift
//  PitchPerfect
//
//  Created by Manthan Keim on 19/04/19.
//  Copyright © 2019 Manthan Keim. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audiorecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recording: UIButton!
    @IBOutlet weak var stoprecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stoprecording.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewwillAppear is called")
    }
    @IBAction func recordAudio(_ sender: UIButton) {
        print("sdsd")
        recordingLabel.text = "Recording in Progress"
        stoprecording.isEnabled = true
        recording.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath ?? "wrong")
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audiorecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audiorecorder.delegate = self
        audiorecorder.isMeteringEnabled = true
        audiorecorder.prepareToRecord()
        audiorecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recording.isEnabled = true
        stoprecording.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audiorecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audiorecorder.url)
    }
        else{
        print("recording wasn't successful")
    
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}
