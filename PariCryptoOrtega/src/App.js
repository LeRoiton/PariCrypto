
import React from 'react';
import { QueryClient, QueryClientProvider } from 'react-query';
import { ReactQueryDevtools } from 'react-query/devtools';
import VoteForm from './components/VoteForm';
import BetInfo from './components/BetInfo';

const queryClient = new QueryClient();

function App() {
  const contractAddress = '0x...'; // Adresse du contrat PrediContrat
  const userAddress = '0x...'; // Adresse de l'utilisateur

  return (
    <QueryClientProvider client={queryClient}>
      <div>
        <h1>Système de Vote</h1>
        <VoteForm contractAddress={contractAddress} userAddress={userAddress} />
        <BetInfo contractAddress={contractAddress} userAddress={userAddress} />
      </div>
      <ReactQueryDevtools />
    </QueryClientProvider>
  );
}

export default App;
