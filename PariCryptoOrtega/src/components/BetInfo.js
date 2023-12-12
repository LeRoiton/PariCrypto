
import React from 'react';
import { useQuery } from 'react-query';
import { createContract, executeScript } from '@forge/cli';

const BetInfo = ({ contractAddress, userAddress }) => {
  const contract = createContract('PrediContrat', contractAddress);

  const { data: betInfo } = useQuery('betInfo', async () => {
    // Appeler la fonction pour obtenir les informations sur le pari
    return executeScript('getBetInfo', contract, userAddress);
  });

  if (!betInfo) {
    return <div>Chargement des informations...</div>;
  }

  return (
    <div>
      <h2>Informations sur le Pari</h2>
      <p>Prediction: {betInfo.prediction}</p>
      <p>Montant du pari: {betInfo.amount}</p>
      <p>Statut du pari: {betInfo.claimed ? 'Réclamé' : 'Non réclamé'}</p>
    </div>
  );
};

export default BetInfo;
