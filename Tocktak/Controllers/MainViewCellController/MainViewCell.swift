//
//  ExampleCell.swift
//  Tocktak
//

// Initialization code

import UIKit
import AVKit
import AVFoundation
import MarqueeLabel

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
    var player : AVPlayer?
    var playerViewController = AVPlayerViewController()
    var postModel : PostModel?
    
    @IBOutlet weak var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightStackView.backgroundColor = .clear
        
        let tempImage = playIcon.image!.withShadow(blur: 2, offset: CGSize.init(width: 0, height: 0), color: .black)
        playIcon.image =  tempImage.resize(targetSize: CGSize(width: 50, height: 50))
        
        profileImg.backgroundColor = .clear
        profileImg.layer.cornerRadius = 24
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg?.layer.cornerRadius = (profileImg.bounds.height) / 4


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
              
              userNameLabel.text = "@\(safeData.userName)"
              detailLabel.text = safeData.description
              songNameLabel.text = "\(safeData.songName)    "
              likeCountLabel.text = "\(safeData.likeCount)"
              commentCountLabel.text = "\(safeData.commentCount)"

              profileImg.image =  UIImage(named: "\(safeData.imgStr)")?.resize(targetSize: CGSize(width: 50, height: 50))

              
//              profileButton.setImage( UIImage(named: "\(safeData.imgStr)")?.resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
//
//              profileButton.backgroundColor = .clear
//              profileButton.layer.cornerRadius = 24
//              profileButton.layer.borderWidth = 2
//              profileButton.layer.borderColor = UIColor.white.cgColor
//              profileButton.imageView?.layer.cornerRadius = profileButton.bounds.height / 2.0
             

        }
     }
    
    @objc func songLabelTap(sender: UITapGestureRecognizer) {
        print("Song label was taped")
    }
    
    
    @objc func playerViewTap(sender: UITapGestureRecognizer) {
        print("\(String(describing: postModel?.vdoURL)) : Video is Pause")
        changeState()
        self.showPlayBottonView.isHidden = false

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
        self.showPlayBottonView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
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
        } else {
            player?.play()
            songNameLabel.unpauseLabel()
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
    /// Returns a new image with the specified shadow properties.
    /// This will increase the size of the image to fit the shadow and the original image.
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


