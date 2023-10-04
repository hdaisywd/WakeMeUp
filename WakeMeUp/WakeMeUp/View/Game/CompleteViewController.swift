//
//  CompleteViewController.swift
//  WakeMeUp
//
//  Created by 정동교 on 2023/10/04.
//

import UIKit

class CompleteViewController : UIViewController {
    let backButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
       
        self.view.addSubview(backButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.backgroundColor = UIColor(red: 0.22, green: 0.596, blue: 0.953, alpha: 1)
        backButton.layer.cornerRadius = 4
        backButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 30).isActive = true
        backButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        
        backButton.addTarget(self, action: #selector(backProfile), for: .touchUpInside)
        super.viewDidLoad()
        
    }
    @objc func backProfile() {
        self.presentingViewController?.dismiss(animated: true)
    }
}
