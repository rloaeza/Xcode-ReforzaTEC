//
//  CustomTableViewCell2TableViewCell.swift
//  ReforzaTecv1
//
//  Created by Delfin: Verano Científico on 21/07/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class CustomTableViewCell2: UITableViewCell {
        //deberia lelvar un objeto tipo Materia?
    var cellExists : Bool = false
    //let touchThing = UILongPressGestureRecognizer(target: self, action: #selector(MateriasDisponiblesViewController.cellOpened(sender:)))
    
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var detailsView: UIView! {
        didSet {
            detailsView?.isHidden = true
            detailsView?.alpha = 0
        }
    }
    @IBOutlet weak var descripcionTextView: UITextView!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var heightCons: NSLayoutConstraint!

    @IBOutlet weak var nombreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    @IBAction func descargar(_ sender: Any) {
        print("Descargando la materia de \(nombreLabel.text!)")
    }
    
 
    func animate(duration : Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                //esto evita que una celda sin descripcion se expanda, pero, aunque no tenga descripcion estaria bien que se expanda un poco
                //if  !self.descripcionTextView.text.isEmpty {
                self.detailsView.isHidden = !self.detailsView.isHidden
                //}
                if self.detailsView.alpha == 1 {
                    self.detailsView.alpha = 0.5
                }else {
                    self.detailsView.alpha = 1
                }
            })
        }, completion: { (finished : Bool) in
            //print("Animation completed")
            c()
            
        })
    }

   
    
}
