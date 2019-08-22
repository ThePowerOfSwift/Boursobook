//
//  Notes.swift
//  Boursobook
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

// TODO:    - Supprimer le fichier Notes
//          - Supprimer tous les messages d'alertes dans la console

// MARK: - A voir avec Vincent
/*
    - J'ai essayer de donner une seule responsabilité par classe et d'injecter des dépendance pour
    que le code ne depende pas des framework.
    Par contre, dans les classes "model" j'implemente des fonctions "setValuesForRemoteDatabase"
    et "init(snapchot)" pour se conformer à mon protocole par contre l'implementation des fonctions
    dans les classes dépande de l'utilation de firebase. C'est bon ????
    - Voir la meilleure facon de faire 2 versions avec fichiers ou config differentes
    - Pourquoi une double compilation de boursobook et boursobooktest avec meme erreurs ?
    - difference en debug et release ?
    - Pod Install ????
    - Pourquoi on ne peut importer que des targets dans les tests ?
    - Comment on peut identifier dans le code les portions
    qui ne sont pas testées
 
 
 */

// MARK: - Test pour le flag -DTEST_VERSION et utilisation Firebase dans les test
/*
    - installation podfile sur toutes les targets => toujours erreur sur building test "undefined symbol"
    - import boursobookForTests dans la classe test => toujours erreur sur building test "undefined symbol"
    si je lance un run sur le boursobookForTest = on est bien en TEST_VERSION
    - je repasse la cible sur boursobooktest sur boursobook
 
 - j'avais un probleme dans mon pod file et quand je lançais mes tests, il y avait une double implementation
 des classses FIR dans les tests : il ne savait pas quel objet initialiser et donc les tests plantés
 - pour supprimer ca, j'ai changer mon podfile et j'ai mis à jour cocoapods,
 j'ai refait un pod install avec la config commentée dans mon pod file (suivant procédure web de cocoapods )

 => tjs erreur qu'il ne trouve pas 'firebase'
 - j'ai mis "${PODS_ROOT}/Firebase/Core/Sources" dans mon HEADER_SEARCH_PATHS
 => tjs erreur qu'il ne trouve pas 'firebase'
 - j'ai fait plein de modfi ?? tjs rien
 
 - j'ai modifié mon podfile avec la config actuelle (en ajoutant l'install des pods dans le test)
 => il me mettait ses messages quand je faisais pod install :
 [!] The `BoursobookTests [Debug]` target overrides the `FRAMEWORK_SEARCH_PATHS` build setting
 defined in `Pods/Target Support Files/Pods-BoursobookTests/Pods-BoursobookTests.debug.xcconfig'.
 This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.
 
 [!] The `BoursobookTests [Debug]` target overrides the `HEADER_SEARCH_PATHS` build setting
 defined in `Pods/Target Support Files/Pods-BoursobookTests/Pods-BoursobookTests.debug.xcconfig'.
 This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.
 
 [!] The `BoursobookTests [Release]` target overrides the `FRAMEWORK_SEARCH_PATHS` build setting
 defined in `Pods/Target Support Files/Pods-BoursobookTests/Pods-BoursobookTests.release.xcconfig'.
 This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.
 
 [!] The `BoursobookTests [Release]` target overrides the `HEADER_SEARCH_PATHS` build setting defined
 in `Pods/Target Support Files/Pods-BoursobookTests/Pods-BoursobookTests.release.xcconfig'.
 This can lead to problems with the CocoaPods installation
 - Use the `$(inherited)` flag, or
 - Remove the build settings from the target.

 - J'ai ajouté `$(inherited)` dans `HEADER_SEARCH_PATHS` et dnas `FRAMEWORK_SEARCH_PATHS`
 - J'ai relancé pod install et plus d'erreur
 
 ===>> ca marche
 
 ##### pâr contre si je remet mon posfile avec pareil mais architetude avec abstract ca marche pas
 
 */
