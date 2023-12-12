// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../contracts/PrediContrat.sol";

contract TestPrediContrat is Test{
    PrediContrat prediContrat;
    address owner;
    address user1;

    function beforeAll() public {
        owner = address(this);
        user1 = address(0x1); // Adresse factice pour le test

        prediContrat = new PrediContrat(owner, 60, address(0x123)); // Adresse factice pour le contrat MockAggregator
    }

    function testPlacerPari() public {
        prediContrat.placerPari(PrediContrat.Prediction.Hausse);

        PrediContrat.Pari memory pari = prediContrat.paris(owner);

        Assert.equal(uint(pari.prediction), uint(PrediContrat.Prediction.Hausse), "Prediction incorrecte");
        Assert.equal(pari.montant, 0, "Montant du pari incorrect");
        Assert.equal(pari.reclame, false, "Le pari ne devrait pas etre reclame");
    }

    function testFermerPredictions() public {
        prediContrat.fermerPredictions();

        bool predictionsTerminees = prediContrat.predictionsTerminees();

        Assert.equal(predictionsTerminees, true, "Les predictions devraient etre fermees");
    }

    function testReclamerGagnant() public {
        prediContrat.placerPari(PrediContrat.Prediction.Hausse);
        prediContrat.fermerPredictions();
        prediContrat.reclamer();

        PrediContrat.Pari memory pari = prediContrat.paris(owner);

        Assert.equal(pari.reclame, true, "Le pari devrait etre reclame");
    }

    function testReclamerPerdant() public {
        prediContrat.placerPari(PrediContrat.Prediction.Baisse);
        prediContrat.fermerPredictions();
        prediContrat.reclamer();

        PrediContrat.Pari memory pari = prediContrat.paris(owner);

        Assert.equal(pari.reclame, true, "Le pari devrait etre reclame");
    }

    function testReclamerSansPari() public {
        prediContrat.fermerPredictions();
        prediContrat.reclamer();

        PrediContrat.Pari memory pari = prediContrat.paris(owner);

        Assert.equal(pari.reclame, true, "Le pari devrait etre reclame");
    }

    function testPlacerPariPredictionInvalide() public {
        try prediContrat.placerPari(PrediContrat.Prediction.Aucune) {
            Assert.fail("Devrait echouer avec une prediction invalide");
        } catch Error(string memory) {
            // Succès
        }
    }
}
