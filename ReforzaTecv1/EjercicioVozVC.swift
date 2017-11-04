//
//  EjercicioVozVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/3/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
import Speech

class EjercicioVozVC: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var PretuntaTextView: UITextView!
    @IBOutlet weak var BotonRevisar: UIButton!
    @IBOutlet weak var BotonMicrofono: UIButton!
    @IBOutlet weak var EntradaField: UITextField!
    @IBOutlet weak var CalificacionImagenView: UIImageView!
    @IBOutlet weak var AlturaDeImagenConstraint: NSLayoutConstraint!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-MX"))
    private var solicitudDeReconocimiento: SFSpeechAudioBufferRecognitionRequest?
    private var tareaDeReconocimiento: SFSpeechRecognitionTask?
    private let motorDeAudio = AVAudioEngine()
    
    var color: UIColor! = UIColor.cyan

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // iniciando boton
        BotonRevisar.backgroundColor = UIColor.white
        BotonRevisar.addTarget(self, action: #selector(accionDelBoton), for: .touchDown)
        BotonRevisar.layer.cornerRadius = 10
        BotonRevisar.layer.borderWidth = 1.5
        BotonRevisar.layer.borderColor = color.cgColor
        BotonRevisar.setTitleColor( #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .disabled)
        BotonRevisar.isEnabled = false
        
        
        // Ocultando la imagen
        AlturaDeImagenConstraint.constant = 0
        CalificacionImagenView.alpha = 0
        
        // TODO: Modificar el alpha del boton para que cuando este dsabilitado se vea diferente
        BotonMicrofono.isEnabled = false
        
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization({(estadoAutorizacion) in
            var habilitarBoton = false
            switch estadoAutorizacion{
            case .authorized:
//                print("autorizaos!")
                habilitarBoton = true
            case .denied:
                print("denegados")
                habilitarBoton = false
            case .notDetermined:
                print("no determinado")
                habilitarBoton = false
            case .restricted:
                print("restringidos")
                habilitarBoton = false
            }
            OperationQueue.main.addOperation {
                self.BotonMicrofono.isEnabled = habilitarBoton
            }
        })
        
        
    }
    
    @objc func accionDelBoton(sender: UIButton) {
        let titulo = sender.title(for: .normal)!
        switch titulo {
        case "Revisar":
            revisarEjercicio()
        case "Siguiente":
            siguienteEjercicio()
        default:
            print("Wow titulo desconocido")
        }
    }
  
    @IBAction func accionDelBoton(_ sender: Any) {
        if motorDeAudio.isRunning{
            motorDeAudio.stop()
            print("Motor de audio detenido")
            solicitudDeReconocimiento?.endAudio()
            BotonMicrofono.isEnabled = false // ??
        } else{
            iniciarGrabacion()
            
        }
    }
    
    func revisarEjercicio() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.AlturaDeImagenConstraint.constant = 64
            self.CalificacionImagenView.alpha = 1
            self.BotonRevisar.setTitle("Siguiente", for: .normal)
        })
    }
    
    func siguienteEjercicio() {
        print("Luego que?")
    }
    
    // MARK:- Voz
    
    @IBAction func MuteMicrofono(_ sender: Any) {
        print("No mas ejercicios de voz en un rato")
    }
    
    func iniciarGrabacion(){
        if tareaDeReconocimiento != nil {
            tareaDeReconocimiento?.cancel()
            tareaDeReconocimiento = nil
        }
        let sesionDeAudio = AVAudioSession.sharedInstance()
        do {
            try sesionDeAudio.setCategory(AVAudioSessionCategoryRecord)
            try sesionDeAudio.setMode(AVAudioSessionModeMeasurement)
            try sesionDeAudio.setActive(true, with: .notifyOthersOnDeactivation)
        } catch{
            print("Error al ponerle las propiedades a la sesion de audio")
        }
        solicitudDeReconocimiento = SFSpeechAudioBufferRecognitionRequest()
        // TODO: revisar esto para que sea mas safe
        let nodoEntrada = motorDeAudio.inputNode
//        guard let inputNode = motorDeAudio.inputNode else {
//            fatalError("Audio engine has no input node")
//        }
//        guard let solicitudDeReconocimiento = solicitudDeReconocimiento else {
//            print("Error, no se pudo crear una solicitud de roconocimiento")
//        }
        
        solicitudDeReconocimiento!.shouldReportPartialResults = true
        tareaDeReconocimiento = speechRecognizer?.recognitionTask(with: solicitudDeReconocimiento!, resultHandler: { (resultado, error) in
            var yaTermino = false
            if resultado != nil{
                self.EntradaField.text = resultado?.bestTranscription.formattedString
                yaTermino = (resultado?.isFinal)!
                
            }
            if error != nil || yaTermino{
                self.motorDeAudio.stop()
                nodoEntrada.removeTap(onBus: 0)
                
                self.solicitudDeReconocimiento = nil
                self.tareaDeReconocimiento  = nil
                
                self.BotonMicrofono.isEnabled = true
            }
        })
        let formatoGrabacion = nodoEntrada.outputFormat(forBus: 0)
        nodoEntrada.installTap(onBus: 0, bufferSize: 1024, format: formatoGrabacion, block: {(buffer, when) in
            self.solicitudDeReconocimiento?.append(buffer)
        })
        
        motorDeAudio.prepare()
        do {
            try 	motorDeAudio.start()
            print("motor de audio iniciado")
        }catch{
            print("no se pudo arrancar el motor de audio debido a un error")
        }
        EntradaField.text = "...";
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            BotonMicrofono.isEnabled = true
        }
        else {
            BotonMicrofono.isEnabled = false
        }
    }
}
