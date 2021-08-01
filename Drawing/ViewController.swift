//
//  ViewController.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/22.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    var picture:Picture? = nil
    
    var viewController:UpLoadViewController?
    
    var color:UIColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var picture = Picture(frame:self.view.bounds)
        self.view.addSubview(picture)
        self.picture = picture
        
        var button = UIButton(frame:CGRect(x:self.view.bounds.size.width - 100, y:self.view.bounds.size.height - 100, width:50, height:50))
        button.backgroundColor = UIColor.white
        button.setTitle("Save", for:.normal)
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        picture.addSubview(button)
        
        button.addTarget(self, action:#selector(self.touchDown(button:)), for:.touchDown)
        button.addTarget(self, action:#selector(self.touchDragInside(button:)), for:.touchDragInside)
        button.addTarget(self, action:#selector(self.touchDragOutside(button:)), for:.touchDragOutside)
        button.addTarget(self, action:#selector(self.touchUpInside(button:)), for:.touchUpInside)
        button.addTarget(self, action:#selector(self.touchUpOutside(button:)), for:.touchUpOutside)
        
        var upLoader = UIButton(frame:CGRect(x:50, y:self.view.bounds.size.height - 100, width:50, height:50))
        upLoader.backgroundColor = UIColor.white
        upLoader.setTitle("Up", for:.normal)
        upLoader.setTitleColor(UIColor.systemBlue, for:.normal)
        picture.addSubview(upLoader)
        
        upLoader.addTarget(self, action:#selector(self.touchDown(button:)), for:.touchDown)
        upLoader.addTarget(self, action:#selector(self.touchDragInside(button:)), for:.touchDragInside)
        upLoader.addTarget(self, action:#selector(self.touchDragOutside(button:)), for:.touchDragOutside)
        upLoader.addTarget(self, action:#selector(self.touchUpOutside(button:)), for:.touchUpOutside)
        upLoader.addTarget(self, action:#selector(self.erase(button:)), for:.touchUpInside)
        
        for i in 1...5 {
            
            var colorButton = UIButton(frame:CGRect(x:Int(self.view.bounds.size.width)-60, y:30*i+30, width:30, height:30))
            colorButton.backgroundColor = UIColor(hue:0.2*CGFloat(i), saturation:1.0, brightness:1.0, alpha:1.0)
            self.view.addSubview(colorButton)
            
            colorButton.addTarget(self, action:#selector(self.colorButtonTouchDown(button:)), for:.touchDown)
            colorButton.addTarget(self, action:#selector(self.colorButtonTouchDragInside(button:)), for:.touchDragInside)
            colorButton.addTarget(self, action:#selector(self.colorButtonTouchDragOutside(button:)), for:.touchDragOutside)
            colorButton.addTarget(self, action:#selector(self.colorButtonTouchUpInside(button:)), for:.touchUpInside)
            colorButton.addTarget(self, action:#selector(self.touchUpOutside(button:)), for:.touchUpOutside)
            
        }
        
        var lineButton = UIButton(frame:CGRect(x:Int(self.view.bounds.size.width)-60, y:240, width:30, height:30))
        lineButton.backgroundColor = UIColor.white
        lineButton.setTitle("1", for:.normal)
        lineButton.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(lineButton)
        
        lineButton.addTarget(self, action:#selector(self.lineButtonTouchDown(button:)), for:.touchDown)
        lineButton.addTarget(self, action:#selector(self.lineButtonTouchDragInside(button:)), for:.touchDragInside)
        lineButton.addTarget(self, action:#selector(self.lineButtonTouchDragOutside(button:)), for:.touchDragOutside)
        lineButton.addTarget(self, action:#selector(self.lineButtonTouchUpInside(button:)), for:.touchUpInside)
        lineButton.addTarget(self, action:#selector(self.lineButtonTouchUpOutside(button:)), for:.touchUpOutside)
        
        var rectangleButton = UIButton(frame:CGRect(x:Int(self.view.bounds.size.width)-60, y:280, width:30, height:30))
        rectangleButton.backgroundColor = UIColor.white
        rectangleButton.setTitle("2", for:.normal)
        rectangleButton.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(rectangleButton)
        
        rectangleButton.addTarget(self, action:#selector(self.rectangleButtonTouchDown(button:)), for:.touchDown)
        rectangleButton.addTarget(self, action:#selector(self.rectangleButtonTouchDragInside(button:)), for:.touchDragInside)
        rectangleButton.addTarget(self, action:#selector(self.rectangleButtonTouchDragOutside(button:)), for:.touchDragOutside)
        rectangleButton.addTarget(self, action:#selector(self.rectangleButtonTouchUpInside(button:)), for:.touchUpInside)
        rectangleButton.addTarget(self, action:#selector(self.rectangleButtonTouchUpOutside(button:)), for:.touchUpOutside)
        
        var heartButton = UIButton(frame:CGRect(x:Int(self.view.bounds.size.width)-60, y:320, width:30, height:30))
        heartButton.backgroundColor = UIColor.white
        heartButton.setTitle("3", for:.normal)
        heartButton.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(heartButton)
        
        heartButton.addTarget(self, action:#selector(self.heartButtonTouchDown(button:)), for:.touchDown)
        heartButton.addTarget(self, action:#selector(self.heartButtonTouchDragInside(button:)), for:.touchDragInside)
        heartButton.addTarget(self, action:#selector(self.heartButtonTouchDragOutside(button:)), for:.touchDragOutside)
        heartButton.addTarget(self, action:#selector(self.heartButtonTouchUpInside(button:)), for:.touchUpInside)
        heartButton.addTarget(self, action:#selector(self.heartButtonTouchUpOutside(button:)), for:.touchUpOutside)
        
    }

    @objc func touchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func touchDragInside(button:UIButton) {
        
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func touchDragOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func touchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
        let alert = UIAlertController(title:nil, message:"保存しますか？", preferredStyle:UIAlertController.Style.alert)
        
        let action = UIAlertAction(title:"はい", style:UIAlertAction.Style.default) {_ in
            
            guard let picture = self.picture else {
                
                return
                
            }

            let image = UIGraphicsImageRenderer(size:picture.bounds.size).image { context in
                
                picture.layer.render(in:context.cgContext)
                
            }
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
        }
        
        let cancelAction = UIAlertAction(title:"いいえ", style:UIAlertAction.Style.default, handler:nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated:true, completion:nil)
        
    }
    
    @objc func touchUpOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func erase(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
        let alert = UIAlertController(title:nil, message:"アップロードしますか？", preferredStyle:UIAlertController.Style.alert)
        
        let action = UIAlertAction(title:"はい", style:UIAlertAction.Style.default) {_ in
                
            let viewController = SignUpViewController()
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated:true, completion:nil)
                
            guard let picture = self.picture else {
                    
                return
                    
            }

            let image = UIGraphicsImageRenderer(size:self.view.bounds.size).image { context in
                    
                picture.layer.render(in:context.cgContext)
                    
            }
                
            viewController.image = image
                
        }
        
        let cancelAction = UIAlertAction(title:"いいえ", style:UIAlertAction.Style.default, handler:nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated:true, completion:nil)
        
        
    }
    
    @objc func colorButtonTouchDown(button:UIButton) {
        
        guard let color = button.backgroundColor else {
            
            return
            
        }
        
        self.color = color
        
        button.backgroundColor = changeColor(color:color)
        
        
    }
    
    @objc func colorButtonTouchDragInside(button:UIButton) {
        
        button.backgroundColor = changeColor(color:self.color)
        
    }
    
    @objc func colorButtonTouchDragOutside(button:UIButton) {
        
        button.backgroundColor = self.color
        
    }
    
    @objc func colorButtonTouchUpInside(button:UIButton) {
        
        button.backgroundColor = self.color
        
        guard let picture = self.picture else {
            
            return
            
        }
        
        picture.color = self.color
        
    }
    
    @objc func colorButtonTouchUpOutside(button:UIButton) {
        
        button.backgroundColor = self.color
        
    }
    
    @objc func lineButtonTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func lineButtonTouchDragInside(button:UIButton) {
        
        button.backgroundColor = UIColor.black
    
    }
    
    @objc func lineButtonTouchDragOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func lineButtonTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
        guard let picture = self.picture else {
            
            return
            
        }
        
        picture.shape = Picture.Shape.line
        
    }
    
    @objc func lineButtonTouchUpOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func rectangleButtonTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func rectangleButtonTouchDragInside(button:UIButton) {
        
        button.backgroundColor = UIColor.black
    
    }
    
    @objc func rectangleButtonTouchDragOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func rectangleButtonTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
        guard let picture = self.picture else {
            
            return
            
        }
        
        picture.shape = Picture.Shape.rectangle
        
    }
    
    @objc func rectangleButtonTouchUpOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func heartButtonTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func heartButtonTouchDragInside(button:UIButton) {
    
        button.backgroundColor = UIColor.black
        
    }
    
    @objc func heartButtonTouchDragOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    @objc func heartButtonTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
        guard let picture = self.picture else {
            
            return
            
        }
        
        picture.shape = Picture.Shape.heart
        
    }
    
    @objc func heartButtonTouchUpOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.white
        
    }
    
    func changeColor(color:UIColor) -> UIColor {
        
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        color.getRed(&red, green:&green, blue:&blue, alpha:nil)
        let changedColor = UIColor(red:red * 0.5, green:green * 0.5, blue:blue * 0.5, alpha:1.0)
        
        return changedColor
        
    }
    
}

