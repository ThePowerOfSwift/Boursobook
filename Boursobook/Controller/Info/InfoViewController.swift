//
//  InfoViewController.swift
//  Boursobook
//
//  Created by David Dubez on 21/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var userLogInLabel: UILabel!
    @IBOutlet weak var userLogInIDLabel: UILabel!
    @IBOutlet weak var currentPurseLabel: UILabel!

    // MARK: - IBActions

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadValues()
    }

    // MARK: - functions
    private func loadValues() {
        userLogInLabel.text = UserService.shared.userLogIn?.email
        userLogInIDLabel.text = UserService.shared.userLogIn?.uid
        currentPurseLabel.text = InMemoryStorage.shared.currentPurse?.name
    }
}

// TODO:    - Statistiques de ventes
//          - Ajouter un contact pour mailing list
//          - Afficher qu'un email a bien été envoye à l'emeil du la création
