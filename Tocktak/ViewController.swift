//
//  ViewController.swift
//  Tocktak
//
//  Created by BOICOMP21070027 on 15/2/2565 BE.
//

import UIKit

class ViewController: UIViewController {
    
    var firstIsPlayed = false
    var currentPlayingIndex:Int = 0
    let segmentedControl = UISegmentedControl(items: ["Following", "For You"])
    
    let customView = UIView()
    var search = UIBarButtonItem()
    var camera = UIBarButtonItem()
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buildNavigationBar()
        buildSegment()
        
        mainCollectionView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView?.contentInsetAdjustmentBehavior = .never
        


        customView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        customView.backgroundColor = UIColor.brown     //give color to the view
        customView.center = self.view.center
        self.view.addSubview(customView)
        customView.isHidden = true
        
        let myLabel = UILabel()
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myLabel.text = "This is Following View"
        myLabel.textAlignment = .center
        customView.addSubview(myLabel)
        
        let widthConstraint = NSLayoutConstraint(item: myLabel, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)

        let heightConstraint = NSLayoutConstraint(item: myLabel, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)

        let xConstraint = NSLayoutConstraint(item: myLabel, attribute: .centerX, relatedBy: .equal, toItem: customView, attribute: .centerX, multiplier: 1, constant: 0)

        let yConstraint = NSLayoutConstraint(item: myLabel, attribute: .centerY, relatedBy: .equal, toItem: customView, attribute: .centerY, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])



//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
//        mainCollectionView.addGestureRecognizer(tap)
        //UIApplication.shared.statusBarStyle = .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
       return .darkContent
   }
    
    func buildSegment() {
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.setiOS12Layout(tintColor: .clear)
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
    }
    
    func buildNavigationBar () {
        //UINavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        //UIBarButtonItem
         search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
         camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        search.tintColor = .white
        camera.tintColor = .white
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem = search
        self.navigationController!.navigationBar.topItem?.leftBarButtonItem = camera
    }
    
    @objc func searchTapped() {
        print("Search button was Tapped")
    }
    
    @objc func cameraTapped() {
        print("Camera button was Tapped")
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
            switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                mainCollectionView.isHidden = true
                customView.isHidden = false
            case 1:
                mainCollectionView.isHidden = false
                customView.isHidden = true
            default:
                break
            }
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
     
        self.tabBarController!.tabBar.standardAppearance = appearance
        self.tabBarController!.tabBar.scrollEdgeAppearance = appearance
        self.tabBarController!.tabBar.tintColor = .black
        self.tabBarController!.tabBar.backgroundColor = .white
        
        //Hide or Remove navigationBar items
        self.navigationController?.navigationBar.topItem?.titleView = UIView()
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem = nil
        self.navigationController!.navigationBar.topItem?.leftBarButtonItem = nil

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
         
        self.tabBarController!.tabBar.standardAppearance = appearance
        self.tabBarController!.tabBar.scrollEdgeAppearance = appearance
        self.tabBarController?.tabBar.tintColor = .white
        self.tabBarController!.tabBar.backgroundColor = .white
        
        //Re build navigationBar items
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController!.navigationBar.topItem?.rightBarButtonItem = search
        self.navigationController!.navigationBar.topItem?.leftBarButtonItem = camera
    }
}




extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
//    @objc func tap(sender: UITapGestureRecognizer){
//        if let indexPath = self.mainCollectionView?.indexPathForItem(at: sender.location(in: self.mainCollectionView)) {
//            let cell = self.mainCollectionView?.cellForItem(at: indexPath) as! MainViewCell
//            print("collection view at indexPath : \(indexPath) was tapped")
//            cell.changeState()
//        } else {
//            print("Not collection view was tapped")
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempViewModels.capacity
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        


        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainViewCell else {
                return UICollectionViewCell()
        }
        cell.postModel = tempViewModels[indexPath.row]


        cell.layoutIfNeeded()
        cell.layoutSubviews()

        cell.songNameLabel.restartLabel()
        cell.playVideo()
        if (!firstIsPlayed) {
            firstIsPlayed = true
            cell.play()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = mainCollectionView.contentOffset
        visibleRect.size = mainCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = mainCollectionView.indexPathForItem(at: visiblePoint) else { return }        

        mainCollectionView.cellForItem(at: indexPath)
        
        let oldIndex = currentPlayingIndex
        if (oldIndex != indexPath.row) {
            if let playCell =  mainCollectionView.cellForItem(at: [0,currentPlayingIndex] ) as? MainViewCell {
                playCell.pause()
                playCell.songNameLabel.pauseLabel()
            }
        }
        currentPlayingIndex = indexPath.row

        if let playCell =  mainCollectionView.cellForItem(at: [0,currentPlayingIndex] ) as? MainViewCell {
            if (currentPlayingIndex != oldIndex) {
                playCell.showPlayBottonView.isHidden = true
                playCell.play(rePlay: true)
                playCell.songNameLabel.restartLabel()
                playCell.songNameLabel.unpauseLabel()

            }
            
            mainCollectionView.visibleCells.forEach { cell in
                let cell = cell as! MainViewCell
                if (cell.postModel?.vdoURL !=   playCell.postModel?.vdoURL) {
                    cell.pause()
                    cell.songNameLabel.pauseLabel()
                    cell.showPlayBottonView.isHidden = true
                }
                
            }
        }

    }
}

extension UISegmentedControl {

    func setiOS12Layout(tintColor: UIColor) {
        if #available(iOS 13, *) {
            let background = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
             let divider = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))
             self.setBackgroundImage(background, for: .normal, barMetrics: .default)
             self.setBackgroundImage(divider, for: .selected, barMetrics: .default)
             self.setDividerImage(divider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
             self.layer.borderWidth = 1
             self.layer.borderColor = tintColor.cgColor
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.50), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)], for: .selected)

        } else {
            self.tintColor = tintColor
        }
    }
}
extension UIImage {

    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let context = UIGraphicsGetCurrentContext()!
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
}
