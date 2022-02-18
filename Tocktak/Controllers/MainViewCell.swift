//
//  ExampleCell.swift
//  Tocktak
//

// Initialization code

import UIKit
import AVKit
import AVFoundation



class MainViewCell: UICollectionViewCell {
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var playerView: UIView!
    var player : AVPlayer?
    var playerViewController = AVPlayerViewController()
    @IBOutlet weak var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightStackView.backgroundColor = .clear
    }
    
     func playVideo(from file:String) {
        let file = file.components(separatedBy: ".")

        guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
            debugPrint( "\(file.joined(separator: ".")) not found")
            return
        }
         self.player?.replaceCurrentItem(with: nil)

        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
         playerLayer.frame = self.playerView.layer.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerViewController.allowsPictureInPicturePlayback = false
         playerViewController.view.frame = self.playerView.layer.bounds
        playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.playerView.addSubview(playerViewController.view)
         self.playerView.layer.addSublayer(playerLayer)
         
         NotificationCenter.default.addObserver(self,
                                                    selector: #selector(restartVideo),
                                                    name: .AVPlayerItemDidPlayToEndTime,
                                                    object: self.player?.currentItem)
    }
    
    @objc func restartVideo() {
        player?.pause()
        player?.currentItem?.seek(to: CMTime.zero, completionHandler: { _ in
            self.player?.play()
        })
    }
    
    func controller(){
        if ((player?.rate != 0) && (player?.error == nil)) {
            // player is playing
            player?.pause()
        } else {
            player?.play()

        }
    }

    func play(rePlay:Bool = true){
        if (rePlay) {
            player?.seek(to: .zero)
        }
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
}
