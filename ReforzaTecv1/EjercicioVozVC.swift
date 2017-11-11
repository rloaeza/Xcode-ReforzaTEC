//
//  EjercicioVozVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/3/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
import Speech

// TODO: Posible bug, si la respuesta correcta es 900, aceptar tambien novecientos

class EjercicioVozVC: UIViewController, SFSpeechRecognizerDelegate {    
    
    @IBOutlet weak var BotonMicrofonoMute: UIBarButtonItem!
    @IBOutlet weak var PretuntaTextView: UITextView!
    @IBOutlet weak var BotonRevisar: UIButton!
    @IBOutlet weak var BotonMicrofono: UIButton!
    @IBOutlet weak var EntradaField: UITextField!
    @IBOutlet weak var CalificacionImagenView: UIImageView!
    @IBOutlet weak var AlturaDeImagenConstraint: NSLayoutConstraint!
    @IBOutlet weak var IndicadorDeActividad: UIActivityIndicatorView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "es-MX"))
    private var solicitudDeReconocimiento: SFSpeechAudioBufferRecognitionRequest?
    private var tareaDeReconocimiento: SFSpeechRecognitionTask?
    private let motorDeAudio = AVAudioEngine()
    
    private var RespuestaCorrecta:String = "900"
    
    var color: UIColor! = UIColor.cyan

    override func viewDidLoad() {
        super.viewDidLoad()

        BotonMicrofonoMute.tintColor = color
        IndicadorDeActividad.tintColor = color
        IndicadorDeActividad.alpha = 0
        
        EntradaField.text = ""
        // para evitar que se muesre un teclado en el cmapo de texto
        EntradaField.inputView = UIView()

        // iniciando boton
        BotonRevisar.backgroundColor = UIColor.white
        BotonRevisar.addTarget(self, action: #selector(accionDelBotonRevisar), for: .touchDown)
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
    
    @objc func accionDelBotonRevisar(sender: UIButton) {
        let titulo = sender.title(for: .normal)!
        switch titulo {
        case "Revisar":
            mostrarCalificacion()
        case "Siguiente":
            siguienteEjercicio()
        default:
            print("Wow titulo desconocido")
        }
    }
  
    @IBAction func accionDelBotonGrabar(_ sender: Any) {
        // habilitar el boton revisar
        BotonRevisar.isEnabled = true
        
        if motorDeAudio.isRunning{
            motorDeAudio.stop()
            solicitudDeReconocimiento?.endAudio()
            print("terminando solicitud de reconocimiento")
            // bloquear boton en lo que la solicitud de reconocmiento entrga su resultado final
            BotonMicrofono.isEnabled = false // ??
        } else{
            iniciarGrabacion()
            
        }
    }
    
    @IBAction func MuteMicrofono(_ sender: Any) {
        if(motorDeAudio.isRunning){
            detenerGrabacion()
        }
        BotonMicrofono.isEnabled = false
        BotonRevisar.isEnabled = true
        self.BotonRevisar.setTitle("Siguiente", for: .normal)
    }
    
    
    
    func respondioBien() -> Bool{
        if let respuestaDelUsuario = EntradaField.text{
            if(respuestaDelUsuario == RespuestaCorrecta){
                return true
            }
        }
        return false
    }
    
    func mostrarCalificacion() {
        if(respondioBien()){
             CalificacionImagenView.image = #imageLiteral(resourceName: "correcto")
        }else{
             CalificacionImagenView.image = #imageLiteral(resourceName: "equivocado")
        }
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
            
            if error != nil || yaTermino || self.respondioBien(){
                self.detenerGrabacion()
                nodoEntrada.removeTap(onBus: 0)
                self.mostrarCalificacion()
                
            }
            
        })
        let formatoGrabacion = nodoEntrada.outputFormat(forBus: 0)
        nodoEntrada.installTap(onBus: 0, bufferSize: 1024, format: formatoGrabacion, block: {(buffer, when) in
            self.solicitudDeReconocimiento?.append(buffer)
        })
        
        motorDeAudio.prepare()
        do {
            try 	motorDeAudio.start()
            self.IndicadorDeActividad.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.IndicadorDeActividad.alpha = 1
            })
            print("grabacion iniciada")
        }catch{
            print("no se pudo arrancar el motor de audio debido a un error")
        }
        //EntradaField.text = "...";
    }
    
    func detenerGrabacion() {
        motorDeAudio.stop()
        solicitudDeReconocimiento = nil
        tareaDeReconocimiento  = nil
        print("grabacion detenida")
        BotonMicrofono.isEnabled = true
        IndicadorDeActividad.alpha = 0
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
