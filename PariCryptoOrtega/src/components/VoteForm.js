
import React, { useState } from 'react';
import { useMutation, useQueryClient } from 'react-query';
import { createContract, executeScript } from '@forge/cli';

const VoteForm = ({ contractAddress, userAddress }) => {
  const [prediction, setPrediction] = useState('');

  const queryClient = useQueryClient();

  const voteMutation = useMutation(
    async (selectedPrediction) => {
      const contract = createContract('PrediContrat', contractAddress);

      // Appeler la fonction de vote sur le contrat
      await executeScript('placerPari', contract, userAddress, selectedPrediction);

      // Rafraîchir les données après le vote
      queryClient.invalidateQueries('betInfo');
    },
    {
      onSuccess: () => {
        // Gérer le succès du vote
        console.log('Vote réussi');
      },
    }
  );

  const handleSubmit = (e) => {
    e.preventDefault();
    voteMutation.mutate(prediction);
  };

  return (
    <div>
      <h2>Vote</h2>
      <form onSubmit={handleSubmit}>
        <label>
          Prediction:
          <select value={prediction} onChange={(e) => setPrediction(e.target.value)}>
            <option value="">Sélectionnez une prédiction</option>
            <option value="1">Hausse</option>
            <option value="2">Baisse</option>
          </select>
        </label>
        <button type="submit" disabled={!prediction || voteMutation.isLoading}>
          Voter
        </button>
      </form>
    </div>
  );
};

export default VoteForm;
