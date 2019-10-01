//
//  Notes.swift
//  Boursobook
//
//  Created by David Dubez on 13/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation

//          - A faire :
/*
            - Voir comment on fait une config en localisation France sans faire de Target differentes ???
 
            - Simpliffier les fonctionnalités non necessaires pour la soutenance
            - Verifier la generation de la page des QRCode
            - ajouter titre et ISBN sur le QR Code

            - mettre un message d'alerte pour dire que l'on a pas de reseau
            - voir ce qui se passe si pas de reseau et pas d'acces ???
            - ajouter sol ou pas sold dans la liste d'article des vendeurs
            - Ajouter des activity indicator dans toutes les vues de info (au chargement des données)
            - Verifier le bon coverage des tests
            - test en release si la base prod fonctionne
            - Supprimer le fichier Notes
            - Supprimer tous les messages d'alertes dans la console
            - faire disparaitre le login si on est déja logé
            - Utiliser KeyChain pour sauvegarder le mot de passe
            - gestion de l'appli offligne
            - message si on est pas connecté et que l'on peut pas telecharger les données
            - verifier toutes les tailles d'iphones
            - Mettre à jour les string du storyboard
            - separer les storyboard
            - Ajouter un bouton pour acces liste transaction dans info de purse et pouvoir en supprimer une
            - factoriser la mise en place des scroll view avec le claviuer
            - factoriser le formatgae des nombres
            - factoriser le formatDiplayedNumber et l'inverse

*/

// MARK: - A voir avec Vincent
/*
 - Comment on peut passer des information de retours entre VC qui ne sont pas lié par un segue direct ?
 - Large Style before iOS 13.0 [9] ??
 - Obliger de faire en IOS 10 ??
 - Livrables ??
 - Projet diffuser publiquement ??
 - erreur sur large acrtivity indicator ?



 - Simplifier les blocs de transaction

 - test du reseau mauvais ? (network conditionner appli sur le mac )
 https://mattmiklic.com/2018/02/19/enabling-network-link-conditioner-on-iphone-and-ipad/

 - Pourquoi sur les tests de API,  le completionHandler(PAPIError.other, nil)
 n'est pas marqué tester alors que oui ? Return ??

 
 - A voir programmation RxSwift => Reactive Programming

    "" self.setPurses()
         .then {
             self.setSellers()
         }
         .then {
             self.setArticle
         }
    ""
 
 */

// MARK: - UserAPI
/*
 - ecouter si l'utilisateur est toujours loger et sortir de l'appli si non et arreter l'ecoute si on sort de l'appli
 
 */

// MARK: - InMemoryStorage
/*
 - gestion de l'appli offligne
 - valider l'entrée dans l'appli meme s'il n'y a pas de seller, de article ou de transactions
 
 */

// MARK: - scanningVC
/*
 - Gerer optionnel videoPreviewLayer ???
 - Voir probleme affichage de la camera

 
 */

// MARK: - SellerVC
/*
 - Traiter la partie pour la restitution des livres
 - Améliorer la résolution des QRCODE et la position des ecritures sur les etiquettes (et taille avec des mm)
 - tester generation plusieurs pages d'étiquettes
 
 */

// MARK: - ArticleListTableVC
/*
 - faire une tri des article suivant leur type
 - afficher que les articles qui ne sont pas vendus
 - Revoir la mise en forme de la cellule
 
 */

// MARK: - AddArticleVC
/*
 - Gerer le format de l'isbn
 - probleme avec certain livre error in JSONDECODER
 
 */

// MARK: - BuyVC
/*
 - Probleme montant calculer sur la part de l'APE
 
 */
//-////////////////////////////////////////
// MARK: - probleme framework firebase
/*
 - It worked, it was enough to change the letter of the folder:
 Pods/Protobuf/objectivec/google/protobuf (protobuf -> Protobuf)
 */

//-////////////////////////////////////////
// MARK: - A faire plus tard
/*
 
 - LoginVC:     Faire fonction "email oublié"
 - UserListVC:  faire une barre avec des lettre pour chercher plus vite les utilisateur
 - InfoVC:      Ajouter un bouton pour acces liste transaction
 - InfoVC:      Ajouter bouton liste articles totaux
 - InfoVC:      Ajouter un contact pour mailing list
 - SellerVC:    Posibilité de modifier les informations des vendeurs
 - SellerVC:    Imprimer la liste des articles vendus et restants PDF par vendeur
                avec les prix de ventes / montants revenants au vendeur
 - SaleVC:      Afficher l'article si on clique dessus
 - ScanQrCodeVC:  faire implementation pour ajouter un article manuellement
 - Divers:      Creer une limite pour le nombre de données par utilisateur
                et donc de faire payer un abonement
 - Divers:      animation par gradient quand ça cherche
 */

// MARK: - Remarque
/*

 - Sur la destruction d'un "seller", je n'enleve pas le montant de la cotisation, ni le montant des articles vendus.
    Par contre, j'efface tous les articles
 - UserListVC:  faire une barre avec des lettre pour chercher plus vite les utilisateur
 - InfoVC:      Ajouter un bouton pour acces liste transaction
 - InfoVC:      Ajouter bouton liste articles totaux
 - InfoVC:      Ajouter un contact pour mailing list
 - SellerVC:    Posibilité de modifier les informations des vendeurs
 - SellerVC:    Imprimer la liste des articles vendus et restants PDF par vendeur
                avec les prix de ventes / montants revenants au vendeur
 - ScanQrCodeVC:  faire implementation pour ajouter un article manuellement
 - Divers:      Creer une limite pour le nombre de données par utilisateur
                et donc de faire payer un abonement
 - Divers:      animation par gradient quand ça cherche
 */
