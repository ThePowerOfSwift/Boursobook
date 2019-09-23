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
    let articleAPI = ArticleAPI()
    var articlesForSearch = [Article]()
    var currentTransaction: Transaction?
    var selectedArticleUniqueID: String?

    // MARK: - IBOutlets
    @IBOutlet weak var scanningView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var upperScanView: UIView!
    @IBOutlet weak var browseArticleButton: UIButton!
    @IBOutlet weak var addManuallyButton: UIButton!

    // MARK: - IBActions
    @IBAction func didTapBrowseArticleButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueToBrowseArticleList", sender: nil)
    }
    @IBAction func didTapAddManuallyButton(_ sender: UIButton) {
        displayAlert(message: NSLocalizedString("Sorry, it's note possible yet !", comment: ""),
        title: NSLocalizedString("Error !", comment: ""))
    }

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoCapture()
        setStyleOfVC()
        toogleScanningView(searching: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticlesForSearch()

        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        articleAPI.stopListen()
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    deinit {
        articleAPI.stopListen()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToArticleFromScan" {
            if let articleVC = segue.destination as? ArticleViewController {
                articleVC.selectedArticleUniqueID = selectedArticleUniqueID
                articleVC.isRegisterSale = true
            }
        }

        if segue.identifier == "segueToBrowseArticleList" {
            if let browseArticleListVC = segue.destination as? BrowseArticleListTableViewController {
                browseArticleListVC.currentTransaction = currentTransaction
            }
        }
    }

    // MARK: - Function

    private func loadArticlesForSearch() {

           articleAPI.loadNoSoldArticlesFor(purse: InMemoryStorage.shared.inWorkingPurse) { (error, loadedArticles) in
               self.toogleScanningView(searching: false)
               if let error = error {
                   self.displayAlert(
                       message: error.message,
                       title: NSLocalizedString(
                           "Error !", comment: ""))
               } else {
                   guard let articles = loadedArticles else {
                       return
                   }
                   self.articlesForSearch = articles
               }
           }
       }

    func failed() {
        displayAlert(message: NSLocalizedString("Scanning not supported", comment: ""),
                     title: NSLocalizedString("Error !", comment: ""))
    }

    func searchArticleWith(code: String) {
        if isExistingArticleWith(code: code)
            && !isCodeArticleInCurrentTransaction(code: code) {
            for article in articlesForSearch where article.code == code {
                selectedArticleUniqueID = article.uniqueID
            }
            self.performSegue(withIdentifier: "segueToArticleFromScan", sender: nil)

        } else if isExistingArticleWith(code: code)
            && isCodeArticleInCurrentTransaction(code: code) {
            presentAlertForCode(message: NSLocalizedString("Article allready scanned", comment: ""))

        } else {
            presentAlertForCode(message: NSLocalizedString("Wrong QRCODE", comment: ""))

        }
    }

    func isExistingArticleWith(code: String) -> Bool {
        for article in articlesForSearch where article.code == code {
            return true
        }
        return false
    }

    func isCodeArticleInCurrentTransaction(code: String) -> Bool {
        guard let transaction = currentTransaction else {
            return false
        }
        for (key, _) in transaction.articles where  key == code {
            return true
        }
        return false
    }

    func presentAlertForCode(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error !", comment: ""),
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.captureSession.startRunning()
        })
        self.present(alert, animated: true, completion: nil)
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

    private func setStyleOfVC() {
        upperScanView.layer.cornerRadius = 10
        browseArticleButton.layer.cornerRadius = 10
        addManuallyButton.layer.cornerRadius = 10
        scanningView.layer.cornerRadius = 10
    }

    func toogleScanningView(searching: Bool) {
        upperScanView.isHidden = searching
        loadingView.isHidden = !searching
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
            searchArticleWith(code: stringValue)
        }
    }
}
