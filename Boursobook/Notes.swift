//
//  Notes.swift
//  Boursobook
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

//TODO: - Supprimer le fichier

// MARK: - A voir avec Vincent
/*
    - Probleme de Flag qui ne passe pas dans les tests
    - Pourquoi une double compilation de boursobook et boursobooktest avec meme erreurs ?
    - difference en debug et release ?
 
    - Double implementation des classses FIR dans les tests? (message dans la console en debut de test)
 
 */

// MARK: - Test pour le flag -DTEST_VERSION
/*
    - installation podfile sur toutes les targets => toujours erreur sur building test "undefined symbol"
    - import boursobookForTests dans la classe test => toujours erreur sur building test "undefined symbol"
    si je lance un run sur le boursobookForTest = on est bien en TEST_VERSION
 
    - je repasse la cible sur boursobooktest sur boursobook
 
 */
