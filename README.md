# PariCrypto
Prediction Market Contract

Par Florian ORTEGA

Ce contrat intelligent (smart contract) en Solidity, appelé PrediContrat, implémente un système de prédiction de marché basé sur les paris sur la hausse ou la baisse des prix d'une cryptomonnaie. Les utilisateurs peuvent placer des paris, fermer les prédictions, et réclamer leurs gains en fonction du résultat du marché.

Fonctionnalités
Placer un Pari : Les utilisateurs peuvent placer des paris sur la hausse ou la baisse des prix d'une cryptomonnaie dans une fenêtre de prédiction déterminée.

Fermer les Prédictions : Le propriétaire du contrat peut fermer les prédictions, indiquant ainsi la fin de la fenêtre de prédiction.

Réclamer les Gains : Les utilisateurs peuvent réclamer leurs gains après la fermeture des prédictions si leur pari est correct.

Configuration Requise :

Node.js (version 12 ou supérieure)
NPM (Node Package Manager)
Forge CLI

Installation :

Clonez ce dépôt : https://github.com/LeRoiton/PariCrypto.git
Installez les dépendances : npm install

Configuration :

Ouvrez le fichier src/App.js et remplacez les valeurs des variables contractAddress et userAddress par les adresses réelles de votre contrat et de votre compte utilisateur.
