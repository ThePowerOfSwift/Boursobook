//
//  ScanBookViewController.swift
//  Boursobook
//
//  Created by David Dubez on 28/07/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import AVFoundation

class ScanBookViewController: UIViewController {

    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    weak var searchingDelegate: SearchingBookDelegate?

    // MARK: - IBOutlet
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var searchingView: UIView!
    @IBOutlet weak var upperScanView: UIView!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyleOfVC()
        toogleScanningView(searching: false)
        setVideoCapture()
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

    // MARK: - Function

    func failed() {
        displayAlert(message: NSLocalizedString("Scanning not supported", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))
    }

    func searchBookWith(isbn: String) {
        let bookService = BookService()
        bookService.getBook(isbn: isbn) { (success, volumeInfo, error) in
            if success, let bookInfo = volumeInfo {
                self.didFindABook(bookInfo, isbn: isbn)
            } else if let error = error {
                self.toogleScanningView(searching: false)
                self.presentAlertForCode(message: NSLocalizedString(error.message, comment: ""))
            }
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

    func didFindABook(_ bookInfo: Book.VolumeInfo, isbn: String) {
        if let searchingDelegateVC = searchingDelegate {
            searchingDelegateVC.didFindExistingBook(info: bookInfo, isbn: isbn)
            navigationController?.popViewController(animated: true)
        }
    }

    private func setVideoCapture() {
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
            captureMetadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }

        // Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = scanView.layer.bounds
            scanView.layer.masksToBounds = true
            scanView.layer.addSublayer(videoPreviewLayer)

            // Start video capture
            captureSession.startRunning()
        }
    }

    private func setStyleOfVC() {
        upperScanView.layer.cornerRadius = 10
        scanView.layer.cornerRadius = 10
    }

    func toogleScanningView(searching: Bool) {
        upperScanView.isHidden = searching
        searchingView.isHidden = !searching
    }
}

// Capture ISBN
extension ScanBookViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        toogleScanningView(searching: true)
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            searchBookWith(isbn: stringValue)
        }
    }
}
