//
//  CompleteViewController.swift
//  WakeMeUp
//
//  Created by 정동교 on 2023/10/04.
//

import UIKit

class CompleteViewController : UIViewController {

    let compleTopImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
    let compleBottomImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
    let randomNum = Int.random(in: 1 ... 5)
    
    override func viewDidLoad() {
        
        self.view.addSubview(compleTopImage)
        self.view.addSubview(compleBottomImage)
        
        compleTopImage.translatesAutoresizingMaskIntoConstraints = false
        compleTopImage.clipsToBounds = true
        compleTopImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        compleTopImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        compleTopImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        compleTopImage.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -37).isActive = true
        compleTopImage.contentMode = .scaleAspectFill
        compleTopImage.layer.masksToBounds = true

        
        compleBottomImage.translatesAutoresizingMaskIntoConstraints = false
        compleBottomImage.clipsToBounds = true
        compleBottomImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        compleBottomImage.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60).isActive = true
        compleBottomImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        compleBottomImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        compleBottomImage.contentMode = .scaleAspectFill
        compleBottomImage.layer.masksToBounds = true

        
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
       
        
        var alert = UIAlertController(title: "당신은 졌습니다.", message: "커피나 닦으러 가쇼 ㅋㅋ", preferredStyle: UIAlertController.Style.alert)
        if(randomNum == 5){
            compleTopImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            compleTopImage.image = UIImage(named: "hidden")
            alert = UIAlertController(title: "당신은 졌지만...행운의 강아지를 발견했습니다!", message: "행운 + 100", preferredStyle: UIAlertController.Style.alert)
        }else{
            compleTopImage.image = UIImage(named: "failTop\(randomNum)")
            compleBottomImage.image = UIImage(named: "failBottom\(randomNum)")
        }
        
        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            self.presentingViewController?.dismiss(animated: false)
            disMisBol = 3
        }
        
        alert.addAction(cancelAction)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.present(alert, animated: true)
        }
    }
    func successMisson () {
        
        
        var alert = UIAlertController(title: "당신은 승리했습니다", message: "상쾌한 하루의 시작!", preferredStyle: UIAlertController.Style.alert)
        
        if(randomNum == 5){
            compleTopImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            compleTopImage.image = UIImage(named: "hidden")
            alert = UIAlertController(title: "헉..상쾌한 커피 한잔과 행운의 댕댕이 발견!", message: "행운 + 10000", preferredStyle: UIAlertController.Style.alert)
        }else{
            compleTopImage.image = UIImage(named: "winTop\(randomNum)")
            compleBottomImage.image = UIImage(named: "winBottom\(randomNum)")
        }
        
        
        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            let userdata = UserDefaults.standard
            // 오늘날짜 찾기
            let imageDateFormatter = DateFormatter()
            imageDateFormatter.dateFormat = "yyyyMMdd"
   
            // 유저 디폴트로 저장된 배열 가져오기
            var arraySet = ["20231001"]
            if let items = userdata.array(forKey: "completeDate") as? [String] {
                arraySet  = items
            }
            
            // 유저 디폴트로 오늘 날짜 추가해서 저장하기
            if(arraySet.last! != imageDateFormatter.string(from: Date())){
                arraySet.append(imageDateFormatter.string(from: Date()) )
                userdata.set(arraySet, forKey: "completeDate")
            }
            
            self.presentingViewController?.dismiss(animated: true)
            disMisBol = 3
        }
        
        alert.addAction(cancelAction)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.present(alert, animated: true)
        }
    }
    @objc func backProfile() {
        self.presentingViewController?.dismiss(animated: false)
    }
}
