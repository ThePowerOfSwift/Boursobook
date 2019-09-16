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
 
 
            - Arreter la syncchro des bases quand l'app n'est plus active et la remttre quand elle arrive
                (est ce que j'arrete la syncho sur chaque VC? )
            
            - mettre un message d'alerte pour dire que l'on a pas de reseau
            - voir ce qui se passe si pas de reseau et pas d'acces ???
            - Ajouter des activity indicator dans toutes les vues ou il y a des acces à la base
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
 
            - Creer une limite pour le nombre de données par utilisateur et donc de faire payer un abonement
*/

// MARK: - A voir avec Vincent
/*
 - test du reseau mauvais ?
 - pas de singleton dans InMemory storage
 - je passe les infos entre controleur en utilisant prepare forsgue
 - j'apelle les classes ..API directement dans les VC
 
 
- Pourquoi sur les tests de API,  le completionHandler(PAPIError.other, nil)
 n'est pas marqué tester alors que oui ? Return ??
 - Comment on passe des infos entre tabview ??? Comment je peux passer un info entre le SelectPurseVC
 et le InfoVC avec prepareforsegue alors que le VC de destination c'est le TabBarControler??
 
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
 - ecouter si l'utilisateur est toujours loger et sortir de l'appli si non
 
 */

// MARK: - Seller
/*
 - calcul des articles à vendre et vendus
 - probleme de la fonction nextnumber si on supprime des articles et qu'on en crée d'autre après
 - Mettre les zero dans le numero d'ordre
 
 */

// MARK: - SellerService
/*
 - gestion erreur dans increase number of article et number of order
 
 */

// MARK: - InMemoryStorage
/*
 - gestion de l'appli offligne
 - valider l'entrée dans l'appli meme s'il n'y a pas de seller, de article ou de transactions
 
 */

// MARK: - AddNewSellerVC
/*
 - Controle du format correct du tel et du mail
 
 */
// MARK: - SellersListVC
/*
 - Voir pourquoi le unwind segue ne fonctionne pas lorsque j'efface l'utilisateur loggé
 
 */
// MARK: - scanningVC
/*
 - Gerer optionnel videoPreviewLayer ???
 - Voir probleme affichage de la camera
 - faire implementation pour ajouter un article manuellement
 
 */

// MARK: - SellerVC
/*
 - Mettre la posibilité de modifier les informations des vendeurs
 - Imprimer la liste des articles vendus et restants PDF
 avec les prix de ventes / montants revenants au vendeur
 - Calculer forfait d'insription en fonction du nombre d'article
 ( et creer une vente fictive pour enregister transaction
 - #### Mettre a jour le montant de desposit fee dans la purse #####
 - Traiter la partie pour la restitution des livres
 - Améliorer la résolution des QRCODE et la position des ecritures sur les etiquettes (et taille avec des mm)
 - tester generation plusieurs pages d'étiquettes
 
 */

// MARK: - ArticleListTableVC
/*
  faire une tri des article suivant leur type
 - afficher que les articles qui ne sont pas vendus
 - gerer le format du prix
 - Revoir la mise en forme de la cellule
 
 */

// MARK: - AddArticleVC
/*
 - Gerer le format du prix / et celui de l'isbn
 - probleme avec certain livre error in JSONDECODER
 
 */

// MARK: - ArticleVC
/*
 - Gerer le format du prix / et celui de l'isbn
 
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

// MARK: - A faire plus tard
/*
 - animation par gradient quand ça cherche
 - Faire fonction "email oublié"
 - faire une barre avec des lettre pour chercher plus vite les utilisateur (UserList TVC)
 - Ajouter un bouton pour acces liste transaction
 - Ajouter bouton liste articles totaux
 - Ajouter un contact pour mailing list
 */
