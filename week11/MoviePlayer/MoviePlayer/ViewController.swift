//
//  ViewController.swift
//  MoviePlayer
//
//  Created by 장고은  on 11/25/24.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayInternalMovie(_ sender: UIButton) {
        // 내부 파일 mp4
        let filePath:String? = Bundle.main.path(forResource: "FastTyping", ofType: "mp4")
        let url = NSURL(fileURLWithPath: filePath!)
        
        playVideo(url: url)
    }
    
    @IBAction func btnPlayExternalMovie(_ sender: UIButton) {
        // 외부 파일 mp4 -> 재생 가능한 링크로 변경 필요
        let url = NSURL(string: "http://cooling.dongduk.ac.kr:8080/data")!
        
        playVideo(url: url)
    }
    
    // 비디오 재생 함수
    private func playVideo(url: NSURL){
        let playerController = AVPlayerViewController()
        
        let player = AVPlayer(url: url as URL)
        playerController.player = player
        
        self.present(playerController, animated: true){
            player.play()
        }
    }
}

