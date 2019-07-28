//
//  ScanViewController.swift
//  Boursobook
//
//  Created by David Dubez on 01/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {

    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var codeOfSelectedArticle: String?

    // MARK: - IBOutlet
    @IBOutlet weak var scanningView: UIView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }

        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            failed()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        // Initialise a AVCapture MetadataOutput objet and set it as the output device to the capture session
        let captureMetadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        // Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = scanningView.layer.bounds
        scanningView.layer.masksToBounds = true
        scanningView.layer.addSublayer(videoPreviewLayer!)

        // Start video capture
        captureSession.startRunning()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticleFromScan" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.codeOfSelectedArticle = codeOfSelectedArticle
                articleVC.isRegisterSale = true
            }
        }
    }
    // MARK: - Function

    func failed() {
        displayAlert(message: NSLocalizedString("Scanning not supported", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))
    }

    func verifyCode(code: String) {
        if InMemoryStorage.shared.isExistingArticleWith(code: code)
            && !InMemoryStorage.shared.isCodeArticleInCurrentTransaction(code: code) {
            codeOfSelectedArticle = code
            self.performSegue(withIdentifier: "segueToArticleFromScan", sender: nil)

        } else if InMemoryStorage.shared.isExistingArticleWith(code: code)
            && InMemoryStorage.shared.isCodeArticleInCurrentTransaction(code: code) {
            presentAlertForCode(message: NSLocalizedString("Article allready scanned", comment: ""))

        } else {
            presentAlertForCode(message: NSLocalizedString("Wrong QRCODE", comment: ""))

        }
    }

    func presentAlertForCode(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error !", comment: ""),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.captureSession.startRunning()
        })
        self.present(alert, animated: true, completion: nil)
    }
}

// Capture QRCode
extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            verifyCode(code: stringValue)
        }
    }
}

// TODO:    - Gerer optionnel videoPreviewLayer ???
//          - Voir probleme affichage de la camera
//          - faire implementation pour ajouter un article manuellement
