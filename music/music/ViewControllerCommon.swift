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
    var timer:Timer!
    @IBOutlet weak var durationLabel: UILabel!
    // 总时间和剩余时间
    
    
    @IBOutlet weak var tempTimeLabel: UILabel!
    // 当前播放时间
    
    
    @IBOutlet weak var volume: UISlider!
    
    
    
   
    
    var volume_plantar: Float = UserSettings.shared.volume_embryology{
        didSet{
            UserSettings.shared.volume_embryology = volume_plantar
            volume.value = volume_plantar
            if player != nil{
                player.volume = volume_plantar
            }
        }
    }
    
    
    var sourceCounts = counts
    var indexOne = 0
    var indexTwo = 0
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var progressBar: UISlider!
    // 进度条
    
    
    @IBOutlet weak var timesTextField: UITextField!
    
    
    @IBOutlet weak var upperScroll: UIScrollView!
    

    
    @IBOutlet weak var stepInCtrl: UIStackView!
    
    
    
    
    
    // MARK:- 开始的地方
    override func viewDidLoad() {
        super.viewDidLoad()
        assingSliderUI()
        
        // Do any additional setup after loading the view, typically from a nib.
        let y = UIApplication.shared.statusBarFrame.height
        view.layer.addUpperLayer(y + 3)
        pickerView.clipsToBounds = true
        
        pickerView.layer.addUpperLayer()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        
        
        progressBar.addTarget(self, action: #selector(changeAudioLocationSlider(_:)), for: UIControl.Event.valueChanged)
        
        indexOne = UserDefaults.standard.integer(forKey: AudioTags.currentIndex.rawValue)
        indexTwo = UserDefaults.standard.integer(forKey: AudioTags.currentSubIndex.rawValue)
        let time = UserDefaults.standard.double(forKey: AudioTags.playerProgress.rawValue)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0) {
            self.playAudio(name: self.tempName, time: time)
        }
        
        let artwork = MPMediaItemArtwork(boundsSize: CGSize(width: 50, height: 50)) { (size) -> UIImage in
            UIImage(named: "output")!
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Deng",
                                                           MPMediaItemPropertyArtwork: artwork,
                                                           MPMediaItemPropertyArtist: "歌"]
        
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            adjustPad()
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            adjustPad()
        }
        
        
        if UIScreen.main.bounds.height == 480{
            adjustPad()
        }
        
    }

    
    
    func adjustPad(){
        buttHeight.constant = 200
        view.layoutIfNeeded()
    }
    
    func playAudio(name str: String, loops counts: Int = 3, time: TimeInterval = 0){
        // Set up the session.
        
        // 代码优化
        var tempPath: String?
        if let mpPath = Bundle.main.path(forResource: str, ofType: "mp3"){
            tempPath = mpPath
        }
        if let maPath = Bundle.main.path(forResource: str, ofType: "m4a"){
            tempPath = maPath
        }
       
        guard let path = tempPath, let playerTmp = try? AVAudioPlayer(data: Data(contentsOf: URL(fileURLWithPath: path))) else{
            return
        }
        self.player = playerTmp
        
        
        
        progressBar.maximumValue = CFloat(player.duration)
        progressBar.minimumValue = 0.0
        progressBar.value = Float(time)
        
        
        
        player.prepareToPlay()
        player.delegate = self
        player.numberOfLoops = counts
        // Activate and request the route.
        
        player.volume = volume_plantar
        
        player.currentTime = time
        player.play()
        UserDefaults.standard.set(indexOne, forKey: AudioTags.currentIndex.rawValue)
        UserDefaults.standard.set(indexTwo, forKey: AudioTags.currentSubIndex.rawValue)
        startTimer()
        durationLabel.numberOfLines = 2
        durationLabel.attributedText = getTime("时长", time: player.duration)
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
            tempTimeLabel.attributedText = getTime( time: player.currentTime)
            
        }
    }
    
    
    
    
    @IBAction func fastBack(_ sender: UIButton) {
        quicklyGo(60 * ( -5 ))
    }
    
    
    
    @IBAction func quickBack(_ sender: UIButton) {
        quicklyGo(60 * ( -10 ))
    }
    
    
    
    
    @IBAction func changeVolume(_ sender: UISlider) {
        volume_plantar = sender.value
    }
    
    
    
    
    @IBOutlet weak var buttHeight: NSLayoutConstraint!
    
    
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
    
    
    
    
    @objc
    func changeAudioLocationSlider(_ sender : UISlider) {
        guard player != nil else{
            alertSongExsit()
            return
        }
        
        
        player.pause()
        player.currentTime = TimeInterval(sender.value)
        configTime()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.player.play()
        }
        
        
    }
    
    
    
    @IBAction func stopIt(_ sender: UIButton) {
        
        stopped = true
        player.stop()
        
    }
    
    
    
    
    
    
    @IBAction func resetCount(_ sender: UIButton) {
        
        sourceCounts = counts
        if let _ = timesTextField.text{
            timesTextField.text = nil
        }
        
    }
    
    
    
    @IBAction func setCount(_ sender: UIButton) {
        let count = counts.count
        if let num = timesTextField.text, let times = Int(num){
            sourceCounts = Array(repeating: times, count: count)
            timesTextField.text = nil
        }
        else{
            sourceCounts = Array(repeating: 2, count: count)
        }
        
        pauseAndPlay()
    }
    
    
    
    func pauseAndPlay(){
        if let player = player {
            player.stop()
        }
        tempTimeLabel.attributedText = NSAttributedString(string: operateStr)
        playAudio(name: tempName, loops: sourceCounts[indexOne])
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
    
    
    //MARK:- Timer
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
    
    @objc func update(_ timer: Timer){
        if !player.isPlaying{
            return
        }
        configTime()
        
        progressBar.value = CFloat(player.currentTime)
        UserDefaults.standard.set(progressBar.value , forKey: AudioTags.playerProgress.rawValue)
        
        
    }

}




extension ViewController: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {}
    
    
}





extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        switch component {
        case 0:
            return DataOne.std.kinds[row]
        default:
            return DataOne.std.datas[indexOne][row]
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
            indexTwo = 0
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            // 为什么我选择以后，这一行代码不会触发断点
        default:
            indexTwo = row
            // 这里打断点
        }
        pauseAndPlay()
        
        // 这里打断点
        // 体会非常的清楚，程序控制硬件，是需要时间的
        //  打断点，会播放两秒钟，才关掉
        
        // 硬件是一种资源，开启和关闭，都需要时间
        timesTextField.resignFirstResponder()
    }
}






extension ViewController: UIPickerViewDataSource{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return DataOne.std.kinds.count
        default:
            return DataOne.std.datas[indexOne].count
        }
        
    }
    
    
    
    var tempName: String{
        get{
            let tmp_indeTwo = indexTwo
            
            
            let name = DataOne.std.sourceDicts["\(indexOne)_\(tmp_indeTwo)"]
            return name ?? "0"
        }
        
        
    }
    
    
    
}






extension ViewController{

    func getTime(_ kind: String = "当前媒体播放到:\n", time inteval: TimeInterval) -> NSAttributedString{
        
        let seconds: Int = Int(inteval) % 60
        let minute: Int = ( Int(inteval) / 60 ) % 60
        let hour: Int = Int(inteval) / ( 60 * 60 )
        let kind = "\(kind)  "
        let time = "\(hour)  _  \(minute)  _  \(seconds)"
        let info = "\(kind)\(time)"
        let result = NSMutableAttributedString(string: info)
        result.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: kind.count))
        result.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red, .font: UIFont.boldSystemFont(ofSize: 16)], range: NSRange(location: info.count - time.count, length: time.count))
        return result.copy() as! NSAttributedString
    }
    
    
    
    func configTime(){
        tempTimeLabel.attributedText = getTime(time: player.currentTime)
        
        
        let durationStr = NSMutableAttributedString(attributedString: getTime("时长:", time: player.duration))
        durationStr.append(NSAttributedString(string: "\n"))
        durationStr.append(getTime("剩余时长:", time: player.duration - player.currentTime))
        durationLabel.attributedText = durationStr.copy() as? NSAttributedString
        
        
    }
    
    
    
    
    func assingSliderUI() {
        let minImage = UIImage(named: "slider-track-fill")?.withRenderingMode(.alwaysTemplate)
        let maxImage = UIImage(named: "slider-track")?.withRenderingMode(.alwaysTemplate)
        let thumb = UIImage(named: "thumb")
        
        progressBar.setMinimumTrackImage(minImage, for: UIControl.State.normal)
        progressBar.minimumTrackTintColor = UIColor.darkGray
        progressBar.setMaximumTrackImage(maxImage, for: UIControl.State.normal)
        progressBar.maximumTrackTintColor = .red
        progressBar.setThumbImage(thumb, for: UIControl.State.normal)
        
        volume.setMinimumTrackImage(minImage, for: UIControl.State.normal)
        volume.minimumTrackTintColor = UIColor.darkGray
        volume.setMaximumTrackImage(maxImage, for: UIControl.State.normal)
        volume.maximumTrackTintColor = .magenta
        volume.setThumbImage(thumb, for: UIControl.State.normal)
        
        volume.minimumValue = 0
        volume.maximumValue = 1
        volume.value = volume_plantar
    }
    
}




