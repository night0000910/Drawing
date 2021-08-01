//
//  SignUpViewController.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController:UIViewController {
    
    var mail:UITextField?
    var passWord:UITextField?
    var userName:UITextField?
    var register:UIButton?
    
    var registerEnabled = false
    
    var number = 0
    
    var image:UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) {(idToken, error) in
            
            if error == nil {
                
                let viewController = UpLoadViewController()
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated:true, completion:nil)
                viewController.image = self.image
                
            }
            
        }
            
        var signUpLabel = UILabel(frame:CGRect(x:80, y:self.view.bounds.size.height*1.5/10, width:self.view.bounds.size.width-160, height:50))
        signUpLabel.text = "アカウントを登録してください"
        self.view.addSubview(signUpLabel)
        
        var mailLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*6)-30, width:self.view.bounds.size.width-200, height:50))
        mailLabel.text = "メールアドレス"
        self.view.addSubview(mailLabel)
        
        self.mail = UITextField(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*5)-30, width:self.view.bounds.size.width-200, height:50))
        
        guard let mail = self.mail else {
            
            return
            
        }
        
        mail.backgroundColor = UIColor.lightGray
        self.view.addSubview(mail)
        mail.delegate = self
        
        var userNameLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*4)-30, width:self.view.bounds.size.width-200, height:50))
        userNameLabel.text = "ユーザー名"
        self.view.addSubview(userNameLabel)
        
        self.userName = UITextField(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*3)-30, width:self.view.bounds.size.width-200, height:50))
        
        guard let userName = self.userName else {
            
            return
            
        }
        
        userName.backgroundColor = UIColor.lightGray
        self.view.addSubview(userName)
        userName.delegate = self
        
        var passWordLabel = UILabel(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*2)-30, width:self.view.bounds.size.width-200, height:50))
        passWordLabel.text = "パスワード"
        self.view.addSubview(passWordLabel)
        
        self.passWord = UITextField(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10-(50*1)-30, width:self.view.bounds.size.width-200, height:50))
        
        guard let passWord = self.passWord else {
            
            return
            
        }
        
        passWord.backgroundColor = UIColor.lightGray
        self.view.addSubview(passWord)
        passWord.delegate = self
        
        self.register = UIButton(frame:CGRect(x:100, y:self.view.bounds.size.height*7/10, width:self.view.bounds.size.width-200, height:50))
        
        guard let register = self.register else {
            
            return
            
        }
        
        register.backgroundColor = UIColor.systemGreen
        register.setTitle("Register", for:.normal)
        register.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(register)
        
        register.addTarget(self, action:#selector(self.registerTouchDown(button:)), for:.touchDown)
        /*register.addTarget(self, action:#selector(self.registerTouchDragInside(button:)), for:.touchDragInside)
        register.addTarget(self, action:#selector(self.registerTouchDragOutside(button:)), for:.touchDragOutside)*/
        register.addTarget(self, action:#selector(self.registerTouchUpInside(button:)), for:.touchUpInside)
        /*register.addTarget(self, action:#selector(self.registerTouchUpOutside(button:)), for:.touchUpOutside)*/
        
        var button = UIButton(frame:CGRect(x:80, y:self.view.bounds.size.height*8/10, width:self.view.bounds.size.width-160, height:50))
        button.setTitle("既にアカウントをお持ちの方", for:.normal)
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action:#selector(self.buttonTouchDown(button:)), for:.touchDown)
        /*button.addTarget(self, action:#selector(self.buttonTouchDragInside(button:)), for:.touchDragInside)
        button.addTarget(self, action:#selector(self.buttonTouchDragOutside(button:)), for:.touchDragOutside)*/
        button.addTarget(self, action:#selector(self.buttonTouchUpInside(button:)), for:.touchUpInside)
        /*button.addTarget(self, action:#selector(self.buttonTouchUpOutside(button:)), for:.touchUpOutside)*/
        
        var returnButton = UIButton(frame:CGRect(x:50, y:self.view.bounds.size.height-100, width:50, height:50))
        returnButton.setTitle("戻る", for:.normal)
        returnButton.setTitleColor(UIColor.systemBlue, for:.normal)
        self.view.addSubview(returnButton)
        
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchDown(button:)), for:.touchDown)
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchUpInside(button:)), for:.touchUpInside)
        
    }
    
    @objc func registerTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.green
        
        if self.registerEnabled == true {
            
            guard let mail = self.mail?.text else {
                
                return
                
            }
            
            guard let passWord = self.passWord?.text else {
                
                return
                
            }
            
            if number >= 6 {
                
                var err = false
                
                Auth.auth().createUser(withEmail:mail, password:passWord) {(res, error) in

                    if let uid = res?.user.uid {
                        
                        guard let userName = self.userName?.text else {
                            
                            return
                            
                        }
                        
                        
                        let documentData = ["mail":mail, "userName":userName] as [String:Any]
                        
                        Firestore.firestore().collection("users").document(uid).setData(documentData) {(error) in
                            
                            if error != nil {
                            
                                let alert = UIAlertController(title:nil, message:"アカウントの登録に失敗しました", preferredStyle:.alert)
                                let action = UIAlertAction(title:"はい", style:.default, handler:nil)
                                alert.addAction(action)
                                self.present(alert, animated:true, completion:nil)
                                
                                guard let error = error else {
                                    
                                    return
                                    
                                }
                                
                                err = true
                        
                            }
                            
                        }
                        
                    }
                    
                }
                
                if err == false {
                    let viewController = UpLoadViewController()
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated:true, completion:nil)
                    viewController.image = image
                    
                }
            
            } else {
                
                let alert = UIAlertController(title:nil, message:"パスワードは6文字以上にしてください", preferredStyle:.alert)
                let action = UIAlertAction(title:"はい", style:.default)
                alert.addAction(action)
                self.present(alert, animated:true, completion:nil)
                
            }
            
        } else {
            
            let alert = UIAlertController(title:nil, message:"メールアドレス、ユーザー名、パスワードを入力してください", preferredStyle:.alert)
            let alertAction = UIAlertAction(title:"はい", style:.default, handler:nil)
            alert.addAction(alertAction)
            
            self.present(alert, animated:true, completion:nil)
            
        }
        
    }
    
    @objc func registerTouchDragInside(button:UIButton) {
        
        button.backgroundColor = UIColor.green
        
    }
    
    @objc func registerTouchDragOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemGreen
        
    }
    
    @objc func registerTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemGreen
        
    }
    
    @objc func registerTouchUpOutside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemGreen
        
    }
    
    @objc func buttonTouchDown(button:UIButton) {
        
        let viewController = SignInViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated:true, completion:nil)
        viewController.image = self.image
        
    }
    
    @objc func buttonTouchDragInside(button:UIButton) {
        
        button.setTitleColor(UIColor.white, for:.normal)
        
        
        
    }
    
    @objc func buttonTouchDragOutside(button:UIButton) {
        
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        
    }
    
    @objc func buttonTouchUpInside(button:UIButton) {
        
        button.setTitleColor(UIColor.systemBlue, for:.normal)
        
    }
    
    @objc func buttonTouchUpOutside(button:UIButton) {
        
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

extension SignUpViewController:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        self.number = self.passWord?.text?.count ?? 0
        let mail = self.mail?.text?.isEmpty ?? true
        let passWord = self.passWord?.text?.isEmpty ?? true
        let userName = self.userName?.text?.isEmpty ?? true
        
        if mail || passWord || userName == true {
            
            self.registerEnabled = false
            
        } else {
            
            self.registerEnabled = true
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}
