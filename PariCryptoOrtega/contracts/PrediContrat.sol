// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";



contract PrediContrat {
    address public proprietaire;
    uint256 public fenetrePrediction; // Durée de la fenêtre de prédiction en secondes
    uint256 public finPredictions; // Heure de fin des prédictions
    bool public predictionsTerminees; // Indicateur de fin des prédictions

    enum Prediction { Aucune, Hausse, Baisse }

    struct Pari {
        Prediction prediction;
        uint256 montant;
        bool reclame;
    }

    mapping(address => Pari) public paris;
    AggregatorV3Interface public priceFeed;

    event PariPlace(address indexed utilisateur, Prediction prediction, uint256 montant);
    event PariReclame(address indexed utilisateur, uint256 montant);

    modifier seulementProprietaire() {
        require(msg.sender == proprietaire, "Il faut etre le proprietaire");

        _;
    }

    modifier predictionsOuvertes() {
        require(block.timestamp < finPredictions && !predictionsTerminees, "Les predictions sont fermees");
        _;
    }

    modifier predictionsTermineesOuReclamees() {
        require(block.timestamp >= finPredictions || predictionsTerminees, "Les predictions sont toujours ouvertes");
        require(paris[msg.sender].reclame, "Pari non reclame");
        _;
    }

    constructor(
        address _proprietaire,
        uint256 _fenetrePrediction,
        address _adressePriceFeed
    ) {
        proprietaire = _proprietaire;
        fenetrePrediction = _fenetrePrediction;
        finPredictions = block.timestamp + _fenetrePrediction;
        predictionsTerminees = false;
        priceFeed = AggregatorV3Interface(_adressePriceFeed);
    }

    function placerPari(Prediction _prediction) external payable predictionsOuvertes {
        require(_prediction != Prediction.Aucune, "Prediction invalide");

        paris[msg.sender] = Pari({
            prediction: _prediction,
            montant: msg.value,
            reclame: false
        });

        emit PariPlace(msg.sender, _prediction, msg.value);
    }

    function fermerPredictions() external seulementProprietaire predictionsOuvertes {
        predictionsTerminees = true;
    }

    function reclamer() external predictionsTermineesOuReclamees {
        require(paris[msg.sender].montant > 0, "Aucun pari place");

        uint256 predictionUtilisateur = paris[msg.sender].prediction == Prediction.Hausse ? 1 : 0;
        (, int256 prix, , , ) = priceFeed.latestRoundData();

        if ((prix > 0 && predictionUtilisateur == 1) || (prix < 0 && predictionUtilisateur == 0)) {
            // L'utilisateur gagne
            uint256 gains = (paris[msg.sender].montant * 2);
            payable(msg.sender).transfer(gains);
            paris[msg.sender].reclame = true;
            emit PariReclame(msg.sender, gains);
        } else {
            // L'utilisateur perd
            paris[msg.sender].reclame = true;
        }
    }
}
