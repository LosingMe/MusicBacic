//
//  ViewController.swift
//  music
//
//  Created by dengjiangzhou on 2019/2/24.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import UIKit

import AVFoundation

import MediaPlayer

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    
    let kinds = ["瑜伽" , "歌曲" , "网络", "meditation"]
    let datas = [["瑜伽仰卧放松休息术"],
                 ["信： 花心"],
                 ["开篇",
                    "UDP", "TCP 1/2", "TCP 2/2",
                  "Socket","http", "https",
                  "直播 流媒体"],
                 ["Guided Body Scan Meditation for Mind & Body Healing"]
                ]
    let sourceDicts = ["0_0": "0",
                       "1_0": "1",
                       "2_9":"10009",
                       "2_10":"10010", "2_11":"1_11",  "2_12":"1_12",
                       "2_13":"1_13", "2_14": "1_14", "2_15":"1_15",
                       "2_16":"1_16",
                       "3_0":"_3"
                       ]
    
    let sourceCounts = [4, 2, 2, 2]
    var indexOne = 0
    var indexTwo = 0
    
    @IBOutlet weak var pickerView: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
            self.playAudio(name: self.tempName)
        }
        
        let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 50, height: 50)) { (size) -> UIImage in
            UIImage(named: "output")!
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Deng",
                                                           MPMediaItemPropertyArtwork: artwork,
                                                           MPMediaItemPropertyArtist: "歌"]
        
    }

    
    func playAudio(name str: String, loops counts: Int = 3 , type format: String = "mp3"){
        // Set up the session.
       
        guard let path = Bundle.main.path(forResource: str, ofType: format), let playerTmp = try? AVAudioPlayer(data: Data(contentsOf: URL(fileURLWithPath: path))) else{
            return
        }
        self.player = playerTmp
        
        player.prepareToPlay()
        player.delegate = self
        player.numberOfLoops = counts
        // Activate and request the route.
        
       
        player.play()
        
        let seconds: Int = Int(player.duration) % 60
        let minute: Int = ( Int( player.duration) / 60 ) % 60
        let hour: Int = Int(player.duration) / ( 60 * 60 )
        
        durationLabel.text = "时长:  \(hour)  _  \(minute)  _  \(seconds)"
        
    }
    
    
    
    
    
    @IBAction func fastAdavance(_ sender: UIButton) {
        quicklyGo(60 * 5)
    }
    
    
    
    @IBAction func quickAdvance(_ sender: UIButton) {
        quicklyGo(60 * 10)
    }
    
    
    
    func quicklyGo(_ time: TimeInterval){
        let go_time: TimeInterval = player.currentTime + time
        
        if go_time < player.duration && go_time > 0 {
            player.currentTime = go_time
            player.prepareToPlay()
            player.play()
        }
    }
    
    
    
    
    @IBAction func fastBack(_ sender: UIButton) {
        quicklyGo(60 * ( -5 ))
    }
    
    
    
    @IBAction func quickBack(_ sender: UIButton) {
        quicklyGo(60 * ( -10 ))
    }
    
    
    
    
     
    
    var stopped: Bool = false
    
    
    @IBAction func pauseIt(_ sender: UIButton) {
        
        if stopped {
            player.currentTime = 0
            player.prepareToPlay()
            player.play()
        }
        else{
            if player.isPlaying{
                player.pause()
            }
            else{
                player.play()
            }
        }
        stopped = false
    }
    
    
    
    
    
    
    
    
    
    @IBAction func stopIt(_ sender: UIButton) {
        
        stopped = true
        player.stop()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    
    
    override func remoteControlReceived(with event: UIEvent?) { // *
        let rc = event!.subtype
        let p = self.player!
       
        switch rc {
        case .remoteControlPlay:
            p.play()
        case .remoteControlPause:
            p.pause()
        default:break
        }
    }

}




extension ViewController: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {}
    
    
}





extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch component {
        case 0:
            return kinds[row]
        default:
            return datas[indexOne][row]
        }
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return view.bounds.width * 0.3
        default:
            return view.bounds.width * 0.7
        }
    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            indexOne = row
            pickerView.reloadComponent(1)
        default:
            indexTwo = row
        }
        if let player = player {
            player.stop()
        }
        
        switch indexOne {
        case 3:
            playAudio(name: tempName, loops: sourceCounts[indexOne] , type: "m4a")
        default:
            playAudio(name: tempName, loops: sourceCounts[indexOne])
        }

    }
}






extension ViewController: UIPickerViewDataSource{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return kinds.count
        default:
            return datas[indexOne].count
        }
        
    }
    
    
    
    var tempName: String{
        get{
            var tmp_indeTwo = indexTwo
            if indexOne == 2{
                tmp_indeTwo += 9
            }
            
            let name = sourceDicts["\(indexOne)_\(tmp_indeTwo)"]
            return name ?? "0"
        }
        
        
    }
    
    
    
}
