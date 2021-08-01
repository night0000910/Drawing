//
//  UpLoadViewController.swift
//  Drawing
//
//  Created by 川口 裕斗 on 2021/07/27.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UpLoadViewController:UIViewController {
    
    var tableView:UITableView?
    var upLoad:UIButton?
    
    var image:UIImage?
    var images:Array<UIImage> = []
    var datas:Array<[String:Any]> = []
    var userNames:Array<String> = [] {
        
        didSet {
            
            if let tableView = self.tableView {
                
                tableView.reloadData()
                
            }
            
        }
        
    }
    
    var uids:Array<String> = []
    
    var uid:String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        Firestore.firestore().collection("users").getDocuments() {(snapshots, error) in
            
            if let error = error {
                print(error)
            }
            snapshots?.documents.forEach {(snapshot) in
                
                self.datas.append(snapshot.data())
                
            }
            
        }
        
        for i in 0..<datas.count {
            
            let userName = self.datas[i]["userName"] as? String ?? ""
                
            self.userNames.append(userName)
            print(userName)
                
            
            
        }
        
        self.tableView = UITableView(frame:CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height*7/8))
        
        guard let tableView = self.tableView else {
            
            return
            
        }
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.upLoad = UIButton(frame:CGRect(x:self.view.bounds.size.width*2/3, y:self.view.bounds.size.height*7/8, width:self.view.bounds.size.width/3, height:self.view.bounds.size.height/8))
        
        guard let upLoad = self.upLoad else {
            
            return
            
        }
        
        upLoad.backgroundColor = UIColor.systemOrange
        upLoad.setTitle("Upload", for:.normal)
        upLoad.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(upLoad)
        
        upLoad.addTarget(self, action:#selector(self.touchDown(button:)), for:.touchDown)
        upLoad.addTarget(self, action:#selector(self.touchUpInside(button:)), for:.touchUpInside)
        
        var returnButton = UIButton(frame:CGRect(x:0, y:self.view.bounds.size.height*7/8, width:self.view.bounds.size.width/3, height:self.view.bounds.size.height/8))
        returnButton.backgroundColor = UIColor.systemRed
        returnButton.setTitle("戻る", for:.normal)
        returnButton.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(returnButton)
        
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchDown(button:)), for:.touchDown)
        returnButton.addTarget(self, action:#selector(self.returnButtonTouchUpInside(button:)), for:.touchUpInside)
        
        var logOut = UIButton(frame:CGRect(x:self.view.bounds.size.width/3, y:self.view.bounds.size.height*7/8, width:self.view.bounds.size.width/3, height:self.view.bounds.size.height/8))
        logOut.backgroundColor = UIColor.systemYellow
        logOut.setTitle("Logout", for:.normal)
        logOut.setTitleColor(UIColor.white, for:.normal)
        self.view.addSubview(logOut)
        
        logOut.addTarget(self, action:#selector(self.logOutTouchDown(button:)), for:.touchDown)
        logOut.addTarget(self, action:#selector(self.logOutTouchUpInside(button:)), for:.touchUpInside)
        
        tableView.reloadData()
        
    }
    
    @objc func touchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.orange
        
        let uid = Auth.auth().currentUser?.uid
        
        guard let uid = uid else {
            
            return
            
        }
        
        let fileName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("Picture").child(uid).child(fileName)
        
        guard let image = self.image else {
            
            return
            
        }
        
        let jpegData = image.jpegData(compressionQuality:0.5)
        
        guard let jpegData = jpegData else {
            
            return
            
        }
        
        storageRef.putData(jpegData, metadata:nil) {(metadata, error) in
            
            if let error = error {
                
                let alert = UIAlertController(title:nil, message:"アップロードに失敗しました", preferredStyle:.alert)
                let action = UIAlertAction(title:"はい", style:.default)
                alert.addAction(action)
                
                self.present(alert, animated:true, completion:nil)
                
            } else {
                
                let alert = UIAlertController(title:nil, message:"アップロードしました", preferredStyle:.alert)
                let action = UIAlertAction(title:"はい", style:.default)
                alert.addAction(action)
                
                self.present(alert, animated:true, completion:nil)
                
            }
            
            
        }
        
        
        
    }
    
    @objc func touchUpInside(button:UIButton){
        
        button.backgroundColor = UIColor.systemOrange
        
    }
    
    @objc func returnButtonTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.red
        
        let viewController = ViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated:true, completion:nil)
        viewController.picture?.picture = image
        
    }
    
    @objc func returnButtonTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemRed
        
    }
    
    @objc func logOutTouchDown(button:UIButton) {
        
        button.backgroundColor = UIColor.yellow
        
        do {
            
            try Auth.auth().signOut()
            
            let viewController = SignInViewController()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated:true, completion:nil)
            viewController.image = self.image
            
        } catch {
            
            let alert = UIAlertController(title:nil, message:"ログアウトに失敗しました", preferredStyle:.alert)
            let action = UIAlertAction(title:"はい", style:.default, handler:nil)
            alert.addAction(action)
            present(alert, animated:true, completion:nil)
            
        }
        
    }
    
    @objc func logOutTouchUpInside(button:UIButton) {
        
        button.backgroundColor = UIColor.systemYellow
        
    }
    
}

extension UpLoadViewController:UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
}

extension UpLoadViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:"cell", for:indexPath)
        
        if cell == nil {
            
            cell = UITableViewCell(style:UITableViewCell.CellStyle.value2, reuseIdentifier:"cell")
            
        }
        
        cell?.textLabel?.text = self.userNames[indexPath.row]
        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        
        return self.userNames.count
        
    }
    
}
