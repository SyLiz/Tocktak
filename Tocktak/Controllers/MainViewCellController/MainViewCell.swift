//
//  ExampleCell.swift
//  Tocktak
//

// Initialization code

import UIKit
import AVKit
import AVFoundation
import MarqueeLabel

protocol NavigateCallHandler {
    func callNavigater(withIdentifier:String, model:Any?)
}

class MainViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var showPlayBottonView: UIView!
    @IBOutlet weak var songNameLabel: MarqueeLabel!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var musicRotate: UIView!
    var player : AVPlayer?
    var playerViewController = AVPlayerViewController()
    var postModel : PostModel?
    var delegate:NavigateCallHandler?
    
    @IBOutlet weak var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightStackView.backgroundColor = .clear
        
        let tempImage = playIcon.image!.withShadow(blur: 2, offset: CGSize.init(width: 0, height: 0), color: .black)
        playIcon.image =  tempImage.resize(targetSize: CGSize(width: 50, height: 50))
        
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg?.layer.cornerRadius = (profileImg.bounds.height) / 2
        
        //musicRotate.startRotating(duration: 6, clockwise: true)
    }
    
    private func rotateImageView() {
        UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: {
            self.musicRotate.transform = self.musicRotate.transform.rotated(by: .pi / 2)

        }) { (finished) in
            if finished {
                self.rotateImageView()
            }
        }
    }
    
     func buildCell() {
          if let safeData = postModel {
              let file = safeData.vdoURL.components(separatedBy: ".")

            guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
                debugPrint( "\(file.joined(separator: ".")) not found")
                return
            }
              player?.replaceCurrentItem(with: nil)
              player = AVPlayer(url: URL(fileURLWithPath: path))
              playerViewController.player = player
              playerViewController.view.frame = playerView.bounds
              playerViewController.videoGravity = .resizeAspectFill
              playerViewController.showsPlaybackControls = false

              playerView.addSubview(playerViewController.view)
             
              NotificationCenter.default.addObserver(self,selector: #selector(restartVideo),name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
              
              let playerViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playerViewTap))
              playerView.addGestureRecognizer(playerViewTap)
              
              let playBottonViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playBottonViewTap))
              showPlayBottonView.addGestureRecognizer(playBottonViewTap)

              let songLabelTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(songLabelTap))
              songView.addGestureRecognizer(songLabelTap)
              
              let profileImgTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImgTap))
              profileImg.addGestureRecognizer(profileImgTap)
              
              let profileLabelTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileLabelTap))
              userNameLabel.addGestureRecognizer(profileLabelTap)
              
              userNameLabel.text = "@\(safeData.userName)"
              detailLabel.text = safeData.description
              songNameLabel.text = "\(safeData.songName)    "
              likeCountLabel.text = "\(safeData.likeCount)"
              commentCountLabel.text = "\(safeData.commentCount)"
              profileImg.image =  UIImage(named: "\(safeData.imgStr)")?.resize(targetSize: CGSize(width: 50, height: 50))
        }
     }
    
    @objc func songLabelTap(sender: UITapGestureRecognizer) {
        print("Song label was taped")
    }
    
    @objc func profileImgTap(sender: UITapGestureRecognizer) {
        print("profileImg was taped")
        delegate?.callNavigater(withIdentifier: AppConstants.kMainToProfileIdentifier, model: postModel)
    }
    
    @objc func profileLabelTap(sender: UITapGestureRecognizer) {
        print("profileLabel was taped")
        delegate?.callNavigater(withIdentifier: AppConstants.kMainToProfileIdentifier, model: postModel)
    }
    
    @objc func playerViewTap(sender: UITapGestureRecognizer) {
        self.showPlayBottonView.isHidden = false
        showPlayBottonView.layoutSubviews()
        print("\(String(describing: postModel?.vdoURL)) : Video is Pause")
        changeState()
        self.showPlayBottonView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            //self.playIcon.center = newCenter
            self.showPlayBottonView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1) // Scale your image

        }) { (success: Bool) in
                //print("Done moving image")
            }
    }
    
    @objc func playBottonViewTap(sender: UITapGestureRecognizer) {
        print("\(String(describing: postModel?.vdoURL)) : Video is Playing")
        showPlayBottonView.isHidden = true
        changeState()
        
    }
    
    @objc func restartVideo() {
        player?.pause()
        player?.currentItem?.seek(to: CMTime.zero, completionHandler: { _ in
            self.player?.play()
        })
    }
    
    func changeState() {
        if ((player?.rate != 0) && (player?.error == nil)) {
            // player is playing
            player?.pause()
            songNameLabel.pauseLabel()
            //musicRotate.stopRotating()
        } else {
            player?.play()
            songNameLabel.unpauseLabel()
            //musicRotate.startRotating(duration: 6, clockwise: true)
        }
    }
    
    func isPlaying() -> Bool {
        if ((player?.rate != 0) && (player?.error == nil)) {
            // player is playing
            return true
        }
        return false
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

extension UIImage {
    func withShadow(blur: CGFloat = 6, offset: CGSize = .zero, color: UIColor = UIColor(white: 0, alpha: 0.8)) -> UIImage {

        let shadowRect = CGRect(
            x: offset.width - blur,
            y: offset.height - blur,
            width: size.width + blur * 2,
            height: size.height + blur * 2
        )
        
        UIGraphicsBeginImageContextWithOptions(
            CGSize(
                width: max(shadowRect.maxX, size.width) - min(shadowRect.minX, 0),
                height: max(shadowRect.maxY, size.height) - min(shadowRect.minY, 0)
            ),
            false, 0
        )
        
        let context = UIGraphicsGetCurrentContext()!

        context.setShadow(
            offset: offset,
            blur: blur,
            color: color.cgColor
        )
        
        draw(
            in: CGRect(
                x: max(0, -shadowRect.origin.x),
                y: max(0, -shadowRect.origin.y),
                width: size.width,
                height: size.height
            )
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return image
    }
    
//    func resizeImage(targetSize: CGSize) -> UIImage {
//        let size = self.size
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//      }
    
    
    func resize(targetSize: CGSize) -> UIImage {
           return UIGraphicsImageRenderer(size:targetSize).image { _ in
               self.draw(in: CGRect(origin: .zero, size: targetSize))
           }
       }

}

extension UIView {

        /**
         Will rotate `self` for ever.

         - Parameter duration: The duration in seconds of a complete rotation (360º).
         - Parameter clockwise: If false, will rotate counter-clockwise.
         */
    func startRotating(duration: Double, clockwise: Bool) {
            let kAnimationKey = "rotation"
            var currentState = CGFloat(0)

            // Get current state
            if let presentationLayer = layer.presentation(), let zValue = presentationLayer.value(forKeyPath: "transform.rotation.z"){
                currentState = CGFloat((zValue as AnyObject).floatValue)
            }

            if self.layer.animation(forKey: kAnimationKey) == nil {
                let animate = CABasicAnimation(keyPath: "transform.rotation")
                animate.duration = duration
                animate.repeatCount = Float.infinity
                animate.fromValue = currentState //Should the value be nil, will start from 0 a.k.a. "the beginning".
                animate.byValue = clockwise ? Float(.pi * 2.0) : -Float(.pi * 2.0)
                self.layer.add(animate, forKey: kAnimationKey)
            }
        }

        /// Will stop a `startRotating(duration: _, clockwise: _)` instance.
        func stopRotating() {
            let kAnimationKey = "rotation"
            var currentState = CGFloat(0)

            // Get current state
            if let presentationLayer = layer.presentation(), let zValue = presentationLayer.value(forKeyPath: "transform.rotation.z"){
                currentState = CGFloat((zValue as AnyObject).floatValue)
            }

            if self.layer.animation(forKey: kAnimationKey) != nil {
                self.layer.removeAnimation(forKey: kAnimationKey)
            }

            // Leave self as it was when stopped.
            layer.transform = CATransform3DMakeRotation(currentState, 0, 0, 1)
        }
}
