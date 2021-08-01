//
//  FirstViewController.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/29.
//

import Foundation
import UIKit

class FirstViewController:UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.cyan
        
        var titleLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*3, width:self.view.bounds.size.width-200, height:50))
        titleLabel.text = "Drawing"
        self.view.addSubview(titleLabel)
        
        var startButton = UIButton(frame:CGRect(x:140, y:self.view.bounds.size.height*6.5/10, width:self.view.bounds.size.width-280, height:50))
        startButton.setTitle("スタート", for:.normal)
        startButton.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(startButton)
        
        startButton.addTarget(self, action:#selector(self.startButtonTouchDown(button:)), for:.touchDown)
        startButton.addTarget(self, action:#selector(self.startButtonTouchDragInside(button:)), for:.touchDragInside)
        startButton.addTarget(self, action:#selector(self.startButtonTouchDragOutside(button:)), for:.touchDragOutside)
        startButton.addTarget(self, action:#selector(self.startButtonTouchUpInside(button:)), for:.touchUpInside)
        startButton.addTarget(self, action:#selector(self.startButtonTouchUpOutside(button:)), for:.touchUpOutside)
        
    }
    
    @objc func startButtonTouchDown(button:UIButton) {
        
        button.setTitleColor(UIColor.lightGray, for:.normal)
        
    }
    
    @objc func startButtonTouchDragInside(button:UIButton) {
        
        button.setTitleColor(UIColor.lightGray, for:.normal)
        
    }
    
    @objc func startButtonTouchDragOutside(button:UIButton) {
        
        button.setTitleColor(UIColor.white, for:.normal)
        
    }
    
    @objc func startButtonTouchUpInside(button:UIButton) {
        
        button.setTitleColor(UIColor.white, for:.normal)
        
        let viewController = ViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated:true, completion:nil)
        
    }
    
    @objc func startButtonTouchUpOutside(button:UIButton) {
        
        button.setTitleColor(UIColor.white, for:.normal)
        
    }
    
}
