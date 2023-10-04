//
//  CompleteViewController.swift
//  WakeMeUp
//
//  Created by 정동교 on 2023/10/04.
//

import UIKit

class CompleteViewController : UIViewController {

    let compleTopImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
    
    override func viewDidLoad() {

        self.view.addSubview(compleTopImage)

        compleTopImage.translatesAutoresizingMaskIntoConstraints = false
        compleTopImage.layer.cornerRadius = compleTopImage.frame.height/2
        compleTopImage.clipsToBounds = true
        compleTopImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        compleTopImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        compleTopImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        compleTopImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        compleTopImage.contentMode = .scaleAspectFill
        compleTopImage.layer.masksToBounds = true
        
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if(disMisBol == 1){
            successMisson()
        }else if(disMisBol == 2){
            failMisson()
        }
    }
    func failMisson () {
        let alert = UIAlertController(title: "", message: "당신은 졌습니다. 커피나 닦으러 가십쇼", preferredStyle: UIAlertController.Style.alert)
        compleTopImage.image = UIImage(named: "picture2")

        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            self.presentingViewController?.dismiss(animated: true)
            disMisBol = 3
        }
        
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    func successMisson () {
        let alert = UIAlertController(title: "", message: "당신은 승리했습니다", preferredStyle: UIAlertController.Style.alert)
        compleTopImage.image = UIImage(named: "picture3")
        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            self.presentingViewController?.dismiss(animated: true)
            disMisBol = 3
        }
        
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    @objc func backProfile() {
        self.presentingViewController?.dismiss(animated: true)
    }
}
