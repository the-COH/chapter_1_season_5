import { ethers } from "ethers";
import React, {
  createContext,
  useContext,
  useEffect, useState
} from "react";
import { useNavigate } from "react-router-dom";
import Web3Modal from "web3modal";
import { ABI, ADDRESS } from "../contract";
import { GetParams } from "../utils/onboard.js";
import { createEventListeners } from "./createEventListeners";

const GlobalContext = createContext();

export const GlobalContextProvider = ({ children }) => {
  const [walletAddress, setWalletAddress] = useState("");
  const [provider, setProvider] = useState("");
  const [contract, setContract] = useState("");
  const [showAlert, setShowAlert] = useState({
    status: false,
    type: "info",
    message: "",
  });
  const [tokenId, setTokenId] = useState("");
  const [gameData, setGameData] = useState({
    players: [],
    pendingBattles: [],
    activeBattle: null,
  });
  const [updateGameData, setUpdateGameData] = useState(0);
  const [battleGround, setBattleGround] = useState("bg-astral");
  const [step, setStep] = useState(1);
  const [errorMessage, setErrorMessage] = useState("");

  const navigate = useNavigate();

  // Reset web3 onboarding modal params
  useEffect(() => {
    const resetParams = async () => {
      const currentStep = await GetParams();

      setStep(currentStep.step);
    };

    resetParams();

    window?.ethereum?.on("chainChanged", () => resetParams());
    window?.ethereum?.on("accountsChanged", () => resetParams());
  }, []);

  const updateCurrentWalletAddress = async () => {
    try {
      const accounts = await window.ethereum.request({
        method: "eth_accounts",
      });

      if (accounts) setWalletAddress(accounts[0]);
    } catch (error) {
      setErrorMessage(error);
    }
  };

  useEffect(() => {
    updateCurrentWalletAddress();

    window.ethereum.on("accountsChanged", updateCurrentWalletAddress);
  }, []);

  // Set smart contract and provider
  useEffect(() => {
    const setSmartContractAndProvider = async () => {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const newProvider = new ethers.providers.Web3Provider(connection);
      const signer = newProvider.getSigner();
      const newContract = new ethers.Contract(ADDRESS, ABI, signer);

      setProvider(newProvider);
      setContract(newContract);
    };

    setSmartContractAndProvider();
  }, []);

  useEffect(() => {
    if (step !== 1 && contract) {
      createEventListeners({
        navigate,
        contract,
        provider,
        walletAddress,
        setShowAlert,
        setUpdateGameData,
      });
    }
  }, [contract, step]);

  useEffect(() => {
    if (showAlert?.status) {
      const timer = setTimeout(() => {
        setShowAlert({ status: false, type: "info", message: "" });
      }, [5000]);
      return () => clearTimeout(timer);
    }
  }, [showAlert]);

  // handle errors
  useEffect(() => {
    if (errorMessage) {
      const parsedErrorMessage = errorMessage?.reason
        ?.slice("execution reverted: ".length)
        .slice(0);

      if (parsedErrorMessage) {
        setShowAlert({
          status: true,
          type: "failure",
          msg: parsedErrorMessage,
        });
      }
    }
  }, [errorMessage]);

  useEffect(() => {
    const fetchGameData = async () => {
      const fetchBattles = await contract.getActiveGame();

      const pendingBattles = fetchBattles.filter(
        (battle) => battle.battleStatus === 0
      ); // 0 = pending

      let activeBattle = null;

      fetchBattles.forEach((battle) => {
        if (
          battle.players.find(
            (player) => player.toLowerCase() === walletAddress.toLowerCase()
          )
        ) {
          // If still active battle, no winner
          if (battle.winner.startsWith("0x00")) {
            activeBattle = battle;
          }
        }
      });

      setGameData({ pendingBattles: pendingBattles.slice(1), activeBattle });
    };

    if (contract) fetchGameData();
  }, [contract]);

  return (
    <GlobalContext.Provider
      value={{
        contract,
        walletAddress,
        showAlert,
        setShowAlert,
        tokenId,
        setTokenId,
        gameData,
        battleGround,
        setBattleGround,
        errorMessage,
        setErrorMessage,
        updateCurrentWalletAddress,
      }}
    >
      {children}
    </GlobalContext.Provider>
  );
};

export const useGlobalContext = () => useContext(GlobalContext);
