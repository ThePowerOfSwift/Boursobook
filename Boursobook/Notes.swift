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
            - Verifier le bon coverage des tests
        (refaire test sale real database ??? avec dispatchgourp
    pour enlever inibeur allerte)
 
 - test sellerAPI with realDB


            - Probleme impression etiquettes 
            - Supprimer le fichier Notes
            - Supprimer tous les messages d'alertes dans la console
            - Mettre à jour les string du storyboard
                    - Verifier si tout passe dans l'appli en francais
            - Livragbles (presentation appli - retour d'ex) 1 page chaque
            - livrables sure le site
            - presentation


*/

// MARK: - A voir avec Vincent
/*

 - Livrables ??



 - test du reseau mauvais ? (network conditionner appli sur le mac )
 https://mattmiklic.com/2018/02/19/enabling-network-link-conditioner-on-iphone-and-ipad/

 - Pourquoi sur les tests de API,  le completionHandler(PAPIError.other, nil)
 n'est pas marqué tester alors que oui ? Return ??

 - Simplifier les blocs de transaction
 - A voir programmation RxSwift => Reactive Programming
    "" self.setPurses()
         .then {
             self.setSellers()
         }
         .then {
             self.setArticle
         }
    ""
 - Voir comment on fait une config en localisation France sans faire de Target differentes ???

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
 
 - LoginVC:         Faire fonction "email oublié"
 - UserListVC:      faire une barre avec des lettre pour chercher plus vite les utilisateur
 - InfoVC:          Ajouter un bouton pour acces liste transaction
 - InfoVC:          Ajouter bouton liste articles totaux
 - InfoVC:          Ajouter un contact pour mailing list
 - SellerVC:        Posibilité de modifier les informations des vendeurs
 - SellerVC:        Imprimer la liste des articles vendus et restants PDF par vendeur
                    avec les prix de ventes / montants revenants au vendeur
 - SaleVC:          Afficher l'article si on clique dessus
 - ScanQrCodeVC:    faire implementation pour ajouter un article manuellement
 - BrowseArtVC:     Ajouter fonction tri par type et index sur le coté avec lettre

 - Divers:          Creer une limite pour le nombre de données par utilisateur
                    et donc de faire payer un abonement
 - Divers:          animation par gradient quand ça cherche
 - Divers:          Regarder si l'utilisateur est toujours logguer
 - Divers:          Utiliser KeyChain pour sauvegarder le mot de passe
 - Divers:          Verif Gestion de l'appli offligne
 - Tests:           test en release si la base prod fonctionne
 - Divers:          factoriser la mise en place des scroll view avec le claviuer
 - Divers:          factoriser le formatgae des nombres
 - Divers:          factoriser le formatDiplayedNumber et l'inverse

 */

// MARK: - Remarques
/*

 - Sur la destruction d'un "seller", je n'enleve pas le montant de la cotisation, ni le montant des articles vendus.
    Par contre, j'efface tous les articles

 */
