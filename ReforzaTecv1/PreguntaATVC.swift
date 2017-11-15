//
//  PreguntaEvaluacionTVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/13/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
// bug con el borde inferior del textfield, no se muestra
class PreguntaATVC: UITableViewCell {

    @IBOutlet weak var PreguntaL: UILabel!
    @IBOutlet weak var RespuestaTF: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // borde solo en la parte de abajo
        RespuestaTF.setBottomBorder()
//        let border = CALayer()
//        let width = CGFloat(1.0)
//        border.borderColor = UIColor.gray.cgColor
//        print(RespuestaTF.frame.size.width)
//        border.frame = CGRect(x: 0, y: RespuestaTF.frame.size.height - width, width:  RespuestaTF.frame.size.width, height: RespuestaTF.frame.size.height)
//
//        border.borderWidth = width
//        RespuestaTF.layer.addSublayer(border)
//        RespuestaTF.layer.masksToBounds = true

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
