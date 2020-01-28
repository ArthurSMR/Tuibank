//
//  ViewController.swift
//  tuibank
//
//  Created by Arthur Rodrigues on 20/12/19.
//  Copyright © 2019 Arthur Rodrigues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //    Outlet Variables
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewHiddingBalance: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var arrowUp: UIImageView!
    @IBOutlet weak var superiorView: UIView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var bancoTitle: UILabel!
    @IBOutlet weak var agenciaTitle: UILabel!
    @IBOutlet weak var contaTitle: UILabel!
    @IBOutlet weak var exitBtn: UIButton!
    
    //    swipeDelta variable is used to calculate how many you swiped
    var swipeDelta = 0 {
        didSet {
            
            if isArrowUp {
                
                //infoView alpha is set up based on swipeDelta value
                //Here I'm calculating this equation to get a value between 0.0 and 1.0
                //This will "animate" the card and the arrow when swiping
                infoView.alpha = 1.0 - CGFloat(Double(swipeDelta * (-1) ) / 400)
                
                //arrowDown alpha is increasing as the swipeDelta increase
                
                if arrowUp.alpha <= 0 {
                    arrowDown.alpha = CGFloat(Double(swipeDelta * (-1) ) / 400)
                } else {
                    arrowDown.alpha = 0.0
                }
                
                //arrowUp alpha is decreasing as the swipeDelta increase
                arrowUp.alpha = 1 - CGFloat(Double(swipeDelta * (-1) ) / 200)
                
            } else {
                infoView.alpha = CGFloat(Double(swipeDelta) / 100)
                
                arrowDown.alpha = 1 - CGFloat(Double(swipeDelta) / 200)
                
                //I did this if because I want that the arrowUp
                //just appear when the down arrow disappear
                if arrowDown.alpha <= 0 {
                    arrowUp.alpha = CGFloat(Double(swipeDelta) / 400)
                } else {
                    arrowUp.alpha = 0.0
                }
            }
        }
    }
    
    //    This variable is used to fill the infoView tableView
    var infos = ["Me ajuda", "Perfil", "Configurar ThuiConta",
                 "Pedir Conta PJ", "Participe da nossa promo",
                 "Configurações do app"]
    
    var images = ["help", "perfil", "moneyWhite", "shop", "star", "phone"]
    
    var isArrowUp = false {
        didSet {
            if isArrowUp {
                //if the arrow is up, infoView needs to appear
                infoView.alpha = 1.0
                
                // up arrow appearing
                arrowDown.alpha = 0.0
                arrowUp.alpha = 1.0
            } else {
                //if the arrow is down, infoView needs to disappear
                infoView.alpha = 0.0
                
                // down arrow appearing
                arrowDown.alpha = 1.0
                arrowUp.alpha = 0.0
            }
        }
    }
    
    var isTheBalanceHidden = false
    
    enum Direction {
        case up
        case down
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bancoTitle.textColor = .white
        agenciaTitle.textColor = .white
        contaTitle.textColor = .white
        
        exitBtn.layer.cornerRadius = 4
        exitBtn.layer.borderWidth = 1
        exitBtn.layer.borderColor = CGColor.init(srgbRed: 149.0/255.0, green: 148.0/255.0, blue: 155.0/255.0, alpha: 0.5)
        
        setGestures()
        registerXibs()
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
    }
    
    /// Method  for setting  up gestures that are used
    private func setGestures() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        self.cardView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.superiorView.addGestureRecognizer(tap)
    }
    
    
    /// This method  is to register the Xibs that are used
    private func registerXibs() {
        let infoNib = UINib(nibName: "InfosTableViewCell", bundle: nil)
        infoTableView.register(infoNib, forCellReuseIdentifier: "infoCell")
    }
    
    
    /// This method  is called when tapping the SuperiorView
    @objc func tap (_ gesture: UITapGestureRecognizer) {
        
        if isArrowUp {
            isArrowUp = false
            move(view: cardView, direction: .up)
        } else {
            isArrowUp = true
            move(view: cardView, direction: .down)
        }
    }
    
    
    /// This method is called  when  you  swipe the cardView
    @objc func swipe(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began || gesture.state == .changed {
            //print(gesture.velocity(in: self.view))
            let translation = gesture.translation(in: self.view)
            gesture.view?.center = CGPoint(x: self.view.frame.maxX/2, y: (gesture.view?.center.y)! + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
            
            //Increasing swipeDelta based on translation y
            self.swipeDelta += Int(translation.y)
        }
        
        if gesture.state == .ended {
            
            self.swipeDelta = 0
            let centroView: CGFloat = (1 / 2) * self.view.frame.maxY
            let doisQuartosView: CGFloat = centroView + 187
            
            //if the swipe is going to the top of the screen
            if (gesture.view?.center.y)! < centroView {
                
                gesture.view?.center = CGPoint(x: self.view.frame.maxY/2, y: 496)
                gesture.setTranslation(CGPoint.zero, in: self.view)
            }
            
            // if the gesture is going up
            if (gesture.view?.center.y)! > centroView && (gesture.view?.center.y)! < doisQuartosView{
                move(view: cardView, direction: .up)
            }
            
            //if the gesture is going down
            if ((gesture.view?.center.y)!) > doisQuartosView {
                move(view: cardView, direction: .down)
            }
        }
    }
    
    
    /// This method is to  move  the card based  on a direction given
    /// - Parameters:
    ///   - view: some view that you want to move
    ///   - direction: up or down
    private func move(view: UIView, direction: Direction) {
        
        switch direction {
        case .up:
            UIView.animate(withDuration: 0.3) {
                view.center = CGPoint(x: self.view.frame.maxX/2, y: 496)
                self.isArrowUp = false
            }
        case .down:
            UIView.animate(withDuration: 0.3) {
                view.center = CGPoint(x: self.view.frame.maxX/2, y: 956)
                self.isArrowUp = true
            }
        }
    }
    
    
    /// This method is to hide  your balance
    @IBAction func hideTheBalance(_ sender: Any) {
        
        isTheBalanceHidden = !isTheBalanceHidden
        
        if isTheBalanceHidden {
            self.viewHiddingBalance.alpha =  1.0
        } else {
            self.viewHiddingBalance.alpha = 0.0
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfosTableViewCell
        
        cell.label.text = infos[indexPath.row]
        cell.tintColor = .white
        cell.icon.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    
}

