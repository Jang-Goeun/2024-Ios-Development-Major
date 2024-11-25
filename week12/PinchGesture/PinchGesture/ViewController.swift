//
//  ViewController.swift
//  PinchGesture
//
//  Created by 장고은 on 11/25/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var txtPinch: UILabel!
    
    // 글자 크기 변수
    var initialFontSize:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 핀 제스처 등록
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
    }
    
    // 액션 메서드
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer){
        if (pinch.state == UIGestureRecognizer.State.began) {
            initialFontSize = txtPinch.font.pointSize
        } else {
            txtPinch.font = txtPinch.font.withSize(initialFontSize * pinch.scale)
        }
    }


}

