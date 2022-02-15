//
//  MainCollectionViewCell.swift
//  Tocktak
//
//  Created by BOICOMP21070027 on 16/2/2565 BE.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("create camera View")
        
        let tabView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60))
        tabView.backgroundColor = UIColor(red: 45/255, green: 58/255, blue: 114/255, alpha: 1)
        if let view = cellView {
            view.addSubview(tabView)
        }
    }

}
