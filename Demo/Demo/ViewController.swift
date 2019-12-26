//
//  ViewController.swift
//  Demo
//
//  Created by Yuiga Wada on 2019/12/24.
//  Copyright © 2019 Yuiga Wada. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YanagiText

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: YanagiText!
    
    private var looper: AVPlayerLooper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
    }
    
    
    private func setupTextView() {
        self.textView.attributedText = self.getAttributedString(string: "* Blue UIView * →→ ") +
            self.getRectangleString(.blue) + self.getAttributedString(string: " ←← \n * Video * →→ ") +
            self.getVideoString() + self.getAttributedString(string: " ←← \n")
        
        self.textView.delegate = self
        self.textView.isEditable = true
    }
    
    
    private func getAttributedString(string: String)-> NSAttributedString {
        let stringAttributes: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 20.0) ]
        
        return NSAttributedString(string: string, attributes:stringAttributes)
    }
    
    
    private func getRectangleString(_ color: UIColor)-> NSAttributedString {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        view.backgroundColor = color
        return self.textView.getViewString(with: view, size: view.frame.size) ?? .init()
    }
    
    private func getVideoString()-> NSAttributedString {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "mp4") else { return .init() }
        
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let item = AVPlayerItem(asset: asset)
        let queuePlayer = AVQueuePlayer(playerItem: item)
        self.looper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        
        let controller = AVPlayerViewController()
        
        controller.player = queuePlayer
        controller.view.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        controller.videoGravity = .resizeAspectFill
        
        self.addChild(controller)
        queuePlayer.play()
        
        return self.textView.getViewString(with: controller.view, size: controller.view.frame.size) ?? .init()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.textView.shouldChangeText(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    
}




extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
}
