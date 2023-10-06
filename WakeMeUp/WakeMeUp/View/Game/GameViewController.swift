//
//  GameViewController.swift
//  WakeMeUp
//
//  Created by 정동교 on 2023/10/04.
//

import UIKit

// 0이면 초기화, 1이면 성공 메세지, 2면 실패 메세지, 3이면 dismiss메세지
var disMisBol = 0

class GameViewController: UIViewController {
    
    var catArmSum : Double = 0.01
    var humanArmSumResult : Double = 0.0
    var humanArmSum : Int = 0
    var tailMoveCount = 0
    var winCount = 40

    @IBOutlet weak var catEarTailView: UIImageView!

    @IBOutlet weak var catRightEyePupil: UIView!
    @IBOutlet weak var catRightEye: UIView!
    
    @IBOutlet weak var catLeftEyePupil: UIView!
    @IBOutlet weak var catLeftEye: UIView!
    
    @IBOutlet weak var catHead: UIView!
    
    @IBOutlet weak var catBody: UIView!
    
    @IBOutlet weak var tableView: UIView!
    
    @IBOutlet weak var humanView: UIView!
    @IBOutlet weak var humanArm: UIView!
    @IBOutlet weak var humanArmHand: UIView!
    
    
    @IBOutlet weak var catArmView: UIView!
    @IBOutlet weak var catArm: UIView!
    @IBOutlet weak var catArmHand: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 고양이 팔 여러번 호출하니 여기에 선언 - tailEyePlay함수
        catArm.translatesAutoresizingMaskIntoConstraints = false
        
        //
        humanArm.translatesAutoresizingMaskIntoConstraints = false
        
        catLeftEye.translatesAutoresizingMaskIntoConstraints = false
 
        catRightEye.translatesAutoresizingMaskIntoConstraints = false

        catHead.translatesAutoresizingMaskIntoConstraints = false
        catHead.clipsToBounds = true
        catHead.layer.cornerRadius = catHead.bounds.height / 2
        
        catArmView.translatesAutoresizingMaskIntoConstraints = false
        catArmView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height / 3).isActive = true
    
        
        catBody.translatesAutoresizingMaskIntoConstraints = false
        catBody.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 10).isActive = true
        catBody.clipsToBounds = true
        catBody.layer.cornerRadius = 24
        catBody.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        
        catEarTailView.translatesAutoresizingMaskIntoConstraints = false
        catEarTailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        catEarTailView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        catEarTailView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        catEarTailView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true

        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.bounds.height / 3).isActive = true
        tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25) .isActive = true
        self.view.sendSubviewToBack(tableView)
        self.view.sendSubviewToBack(catBody)
        
        humanArmHand.clipsToBounds = true
        humanArmHand.layer.cornerRadius = 18
        humanArmHand.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        catArmHand.clipsToBounds = true
        catArmHand.layer.cornerRadius = catArmHand.bounds.height / 2
        catArmHand.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
     
    }
    
    // 결과창에서 돌아왔을 시 실행될 코드 - disMisBol의 값으로 바로 dismiss를 해준다
    override func viewWillAppear(_ animated: Bool) {
        if(disMisBol == 3){
            disMisBol = 0
            self.navigationController?.popViewController(animated: true)
        }
    }
    // 뷰가 나타난 후 띄워줄 게임 스타트 알럿
    override func viewDidAppear(_ animated: Bool) {
        if(disMisBol == 3){
            disMisBol = 0
            self.navigationController?.popViewController(animated: true)
        }
        alertStratButton()
    }
    


    @IBAction func HumanButton(_ sender: Any) {
        catLeftEye.translatesAutoresizingMaskIntoConstraints = false
        catLeftEye.backgroundColor = .white
        catLeftEye.layer.cornerRadius = catLeftEye.bounds.height / 2
        
        catLeftEyePupil.translatesAutoresizingMaskIntoConstraints = false
        catLeftEyePupil.layer.cornerRadius = catLeftEyePupil.bounds.height / 4
        
        catRightEye.translatesAutoresizingMaskIntoConstraints = false
        catRightEye.layer.cornerRadius = catLeftEye.bounds.height / 2
        catRightEye.backgroundColor = .white
        
        catRightEyePupil.translatesAutoresizingMaskIntoConstraints = false
        catRightEyePupil.layer.cornerRadius = catLeftEyePupil.bounds.height / 4

        humanArmSpread()
    }
    
    func tailEyePlay () {
        UIGraphicsBeginImageContext(catEarTailView.bounds.size)
        let context = UIGraphicsGetCurrentContext()!
        
        
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.systemYellow.cgColor)
        context.setFillColor(UIColor.systemYellow.cgColor)

        // 왼쪽귀
        let eare = catHead.frame
     
        context.move(to: CGPoint(x: eare.origin.x + 15 ,y: eare.origin.y - 18)) // 세모의 시작
        context.addLine(to: CGPoint(x: eare.origin.x + 34,y: eare.origin.y + 18)) // 세모의 오른쪽
        context.addLine(to: CGPoint(x: eare.origin.x + 4,y: eare.origin.y + 18)) // 세모의 왼쪽
        context.addLine(to: CGPoint(x: eare.origin.x + 15,y: eare.origin.y - 18))
        
        context.fillPath()
        context.strokePath()
        
        context.move(to: CGPoint(x: eare.origin.x + (eare.width - 18),y:  eare.origin.y - 18))
        context.addLine(to: CGPoint(x: eare.origin.x + (eare.width - 34),y: eare.origin.y + 18))
        context.addLine(to: CGPoint(x: eare.origin.x + (eare.width - 4),y: eare.origin.y + 18))
        context.addLine(to: CGPoint(x: eare.origin.x + (eare.width - 18),y:  eare.origin.y - 18))
        
        context.fillPath()
        context.strokePath()

        context.setLineWidth(12.0)
        context.setStrokeColor(UIColor.systemYellow.cgColor)
        
        context.move(to:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 10,y:  catBody.frame.origin.y + (catBody.frame.height) - 10)
        )
        context.addArc(tangent1End:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 10,y:  catBody.frame.origin.y + (catBody.frame.height) - 40),
                       tangent2End:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 40,y:  catBody.frame.origin.y + (catBody.frame.height) - 40),
                       radius: CGFloat(25)
        )
        
        context.move(to:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 40,y:  catBody.frame.origin.y + (catBody.frame.height) - 40)
        )
        context.addArc(tangent1End:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 50,y:  catBody.frame.origin.y + (catBody.frame.height) - 40),
                       tangent2End:
                        CGPoint(x: catBody.frame.origin.x + (catBody.frame.width) + 50,y:  catBody.frame.origin.y + (catBody.frame.height) - 50),
                       radius: CGFloat(15)
        )
        // 꼬리 끝
        
        let tailMoveX = catBody.frame.origin.x + (catBody.frame.width) + 50
        let tailMoveY = catBody.frame.origin.y + (catBody.frame.height) - 50
        if(tailMoveCount == 0){
            
            context.move(to:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY)
            )
            context.addArc(tangent1End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 40),
                           tangent2End:
                            CGPoint(x: tailMoveX - 10,
                                    y:  tailMoveY - 40),
                           radius: CGFloat(20)
            )
            context.strokePath()
            tailMoveCount = 1
        }else if(tailMoveCount == 1){
           
            context.move(to:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY)
            )
            context.addArc(tangent1End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 50),
                           tangent2End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 50),
                           radius: CGFloat(20)
            )
            context.strokePath()
            tailMoveCount = 2
        }else if(tailMoveCount == 2){
            context.move(to:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY)
            )
            context.addArc(tangent1End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 40),
                           tangent2End:
                            CGPoint(x: tailMoveX + 10,
                                    y:  tailMoveY - 40),
                           radius: CGFloat(20)
            )
            context.strokePath()
            tailMoveCount = 3
        }else if(tailMoveCount == 3){
            context.move(to:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY)
            )
            context.addArc(tangent1End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 50),
                           tangent2End:
                            CGPoint(x: tailMoveX,
                                    y:  tailMoveY - 50),
                           radius: CGFloat(20)
            )
            context.strokePath()
            tailMoveCount = 0
        }

        catEarTailView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // sum이 늘어나면서 고양이 팔이 길어짐
        catArmSum += 0.02
        catArm.heightAnchor.constraint(equalTo: catArmView.heightAnchor, multiplier: catArmSum).isActive = true
        
        // humanArm 길이 감지해서 눈동자 움직이기
        if(humanArmSum < 23){
            
            catLeftEyePupil.leadingAnchor.constraint(equalTo: catLeftEye.leadingAnchor, constant: 5).isActive = true

            catRightEyePupil.leadingAnchor.constraint(equalTo: catRightEye.leadingAnchor, constant: 5).isActive = true

        }else {

            catLeftEyePupil.leftAnchor.constraint(equalTo: catLeftEye.leftAnchor, constant: 10).isActive = true
            catLeftEyePupil.rightAnchor.constraint(equalTo: catLeftEye.rightAnchor, constant: -10).isActive = true
            catLeftEyePupil.bottomAnchor.constraint(equalTo: catLeftEye.bottomAnchor, constant: 0).isActive = true
            catLeftEyePupil.topAnchor.constraint(equalTo: catLeftEye.topAnchor, constant: 0).isActive = true


            catRightEyePupil.leftAnchor.constraint(equalTo: catRightEye.leftAnchor, constant: 10).isActive = true
            catRightEyePupil.rightAnchor.constraint(equalTo: catRightEye.rightAnchor, constant: -10).isActive = true
            catRightEyePupil.topAnchor.constraint(equalTo: catRightEye.topAnchor, constant: 0).isActive = true
            catRightEyePupil.bottomAnchor.constraint(equalTo: catRightEye.bottomAnchor, constant: 0).isActive = true
        }
    }
 
    func humanArmSpread () {
        // multiplier 속성을 이용해서 human의 팔 늘리는 로직, 소숫점 +는 오류가 나서 이렇게 만듬
        if(humanArmSum < 9){
            humanArmSum += 1
            humanArmSumResult = Double("0.0\(humanArmSum)")!

        }else{
            humanArmSum += 1
            humanArmSumResult = Double("0.\(humanArmSum)")!
            // 0.10으로 적용하면 오류남;;
            if(humanArmSum == 10){
                humanArmSumResult = Double("0.1")!
            }
        }
        humanArm.heightAnchor.constraint(equalTo: humanView.heightAnchor, multiplier: humanArmSumResult).isActive = true
        humanArm.topAnchor.constraint(equalTo: humanView.topAnchor, constant: humanView.bounds.height - (humanView.bounds.height * humanArmSumResult)).isActive = true
        humanArm.bottomAnchor.constraint(equalTo: humanView.bottomAnchor, constant: 0).isActive = true
    }
    
    func alertMessge () {
        
        let compleVC = CompleteViewController()
        compleVC.modalTransitionStyle = .coverVertical
        compleVC.modalPresentationStyle = .fullScreen
        disMisBol = 1
        self.present(compleVC, animated: true , completion: nil)
    }
    
    func alertFailMessge () {
        let compleVC = CompleteViewController()
        compleVC.modalTransitionStyle = .coverVertical
        compleVC.modalPresentationStyle = .fullScreen
        disMisBol = 2
        self.present(compleVC, animated: true , completion: nil)
    }
    func alertStratButton () {
        let alert = UIAlertController(title: "", message: "고양이가 당신의 아침을 깨워줄 커피를 노리고 있습니다! 버튼을 연타해 커피를 지키세요!", preferredStyle: UIAlertController.Style.alert)
        

        let cancelAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.destructive){(_) in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.tailEyePlay()
                if(self.humanArmSum >= self.winCount){
                    self.alertMessge()
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.tailEyePlay()
                    if(self.humanArmSum >= self.winCount){
                        self.alertMessge()
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.tailEyePlay()
                        if(self.humanArmSum >= self.winCount){
                            self.alertMessge()
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.tailEyePlay()
                            if(self.humanArmSum >= self.winCount){
                                self.alertMessge()
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                self.tailEyePlay()
                                if(self.humanArmSum >= self.winCount){
                                    self.alertMessge()
                                    return
                                }
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    self.tailEyePlay()
                                    if(self.humanArmSum >= self.winCount){
                                        self.alertMessge()
                                        return
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                        self.tailEyePlay()
                                        if(self.humanArmSum >= self.winCount){
                                            self.alertMessge()
                                            return
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                            self.tailEyePlay()
                                            if(self.humanArmSum >= self.winCount){
                                                self.alertMessge()
                                                return
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                self.tailEyePlay()
                                                if(self.humanArmSum >= self.winCount){
                                                    self.alertMessge()
                                                    return
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                    self.tailEyePlay()
                                                    if(self.humanArmSum >= self.winCount){
                                                        self.alertMessge()
                                                        return
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                        self.tailEyePlay()
                                                        if(self.humanArmSum >= self.winCount){
                                                            self.alertMessge()
                                                            return
                                                        }
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                            self.tailEyePlay()
                                                            if(self.humanArmSum >= self.winCount){
                                                                self.alertMessge()
                                                                return
                                                            }
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                                self.tailEyePlay()
                                                                if(self.humanArmSum >= self.winCount){
                                                                    self.alertMessge()
                                                                    return
                                                                }
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                                                    self.tailEyePlay()
                                                                    if(self.humanArmSum >= self.winCount){
                                                                        self.alertMessge()
                                                                        return
                                                                    }
                                                                    
                                                                    self.alertFailMessge()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        alert.addAction(cancelAction)

        present(alert, animated: true)
        
    }
}
