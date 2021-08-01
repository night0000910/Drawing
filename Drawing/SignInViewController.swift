//
//  SignInViewController.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/26.
//

import Foundation
import Firebase
import FirebaseAuth

class SignInViewController:UIViewController{
    
    var mail:UITextField?
    var passWord:UITextField?
    var authentication:UIButton?
    
    var authenticationEnabled = false
    
    var number = 0
    
    var image:UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        var signInLabel = UILabel(frame:CGRect(x:110, y:self.view.bounds.size.height*1.8/10, width:self.view.bounds.size.width-220, height:50))
        signInLabel.text = "ログインしてください"
        self.view.addSubview(signInLabel)
        
        var mailLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*6.5/10-(50*4)-30, width:self.view.bounds.size.width-200, height:50))
        mailLabel.text = "メールアドレス"
        self.view.addSubview(mailLabel)
        
        self.mail = UITextField(frame:CGRect(x:100, y:self.view.bounds.size.height*6.5/10-(50*3)-30, width:self.view.bounds.size.width-200, height:50))
        
        guard let mail = self.mail else {
            
            return
            
        }
        
        mail.backgroundColor = UIColor.lightGray
        self.view.addSubview(mail)
        mail.delegate = self
        
        var passWordLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*6.5/10-(50*2)-30, width:self.view.bounds.size.width-200, height:50))
        passWordLabel.text = "パスワード"
        self.view.addSubview(passWordLabel)
        
        self.passWord = UITextField(frame:CGRect(x:100, y:self.view.bounds.size.height*6.5/10-(50*1)-30, width:self.view.bounds.size.width-200, height:50))
        
        guard let passWord = self.passWord else {
            
            return
            
        }
        
        passWord.backgroundColor = UIColor.lightGray
        self.view.addSubview(passWord)
        passWord.delegate = self
        
        self.authentication = UIButton(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10, width:self.view.bounds.size.width-200, height:50))
        
        guard let authentication = self.authentication else {
            
            return
            
        }
        
        authentication.backgroundColor = UIColor.systemGreen
        authentication.setTitle("Login", for:.normal)
        authentication.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(authentication)
        
        authentication.addTarget(self, action:#selector(self.authenticationTouchDown(button:)), for:.touchDown)
        authentication.addTarget(self, action:#selector(self.authenticationTouchUpInside(button:)), for:.touchUpInside)
        
        var button = UIButton(frame:CGRect(x:60, y:self.view.bounds.size.height*8/10, width:self.view.bounds.size.width-120, height:50))
        button.setTitle("まだアカウントをお持ちでない方", for:.normal)
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action:#selector(self.buttonTouchDown(button:)), for:.touchDown)
        button.addTarget(self, action:#selector(self.buttonTouchUpInside(button:)), for:.touchUpInside)
        
        var returnButton = UIButton(frame:CGRect(x:50, y:self.view.bounds.size.height-100, width:50, height:50))
        returnButton.setTitle("戻る", for:.normal)
        returnButton.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(returnButton)
        
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchDown(button:)), for:.touchDown)
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchUpInside(button:)), for:.touchUpInside)
        
    }
    
    @objc func authenticationTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.green
        
        if authenticationEnabled == true {
            
            guard let mail = self.mail?.text else {
                
                return
                
            }
            
            guard let passWord = self.passWord?.text else {
                
                return
                
            }
            
            if number >= 6 {
                
                Auth.auth().signIn(withEmail:mail, password:passWord) {(res, err) in
                    
                    if let err = err {
                        
                        let alert = UIAlertController(title:nil, message:"ログインに失敗しました", preferredStyle:.alert)
                        let action = UIAlertAction(title:"はい", style:.default, handler:nil)
                        alert.addAction(action)
                        self.present(alert, animated:true, completion:nil)
                        
                        
                    } else {
                        
                        let viewController = UpLoadViewController()
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated:true, completion:nil)
                        viewController.image = self.image
                        
                    }
                    
                }
                
            } else {
                
                let alert = UIAlertController(title:nil, message:"パスワードは6文字以上です", preferredStyle:.alert)
                let action = UIAlertAction(title:"はい", style:.default)
                alert.addAction(action)
                present(alert, animated:true, completion:nil)
                
            }
            
        } else {
            
            let alert = UIAlertController(title:nil, message:"メールアドレス、パスワードを入力してください", preferredStyle:.alert)
            let action = UIAlertAction(title:"はい", style:.default, handler:nil)
            alert.addAction(action)
            self.present(alert, animated:true, completion:nil)
            
        }
        
    }
    
    @objc func authenticationTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemGreen
        
    }
    
    @objc func buttonTouchDown(button:UIButton) {
        
        let viewController = SignUpViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated:true, completion:nil)
        viewController.image = image
        
    }
    
    @objc func buttonTouchUpInside(button:UIButton) {
        
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        
    }
    
    @objc func returnButtonTouchDown(button:UIButton) {
        
        button.setTitleColor(UIColor.white, for:.normal)
        
        let viewController = ViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated:true, completion:nil)
        viewController.picture?.picture = image
        
        
    }
    
    @objc func returnButtonTouchUpInside(button:UIButton) {
        
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        
    }
    
}

extension SignInViewController:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        self.number = self.passWord?.text?.count ?? 0
        let mail = self.mail?.text?.isEmpty ?? true
        let passWord = self.passWord?.text?.isEmpty ?? true
        
        if mail || passWord == true {
            
            self.authenticationEnabled = false
            
        } else {
            
            self.authenticationEnabled = true
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
