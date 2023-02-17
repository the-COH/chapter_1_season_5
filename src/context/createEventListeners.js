import { ethers } from "ethers";

import { ABI } from "../contract";

const emptyAccount = "0x0000000000000000000000000000000000000000";

const AddNewEvent = (eventFilter, provider, cb) => {
  provider.removeListener(eventFilter); // ensures that we don't have multiple listeners at once.

  provider.on(eventFilter, (logs) => {
    const parsedLog = new ethers.utils.Interface(ABI).parseLog(logs);

    cb(parsedLog);
  });
};

const getCoords = (cardRef) => {
  const { left, top, width, height } = cardRef.current.getBoundingClientRect();

  return {
    pageX: left + width / 2,
    pageY: top + height / 2.25,
  };
};

export const createEventListeners = ({
  navigate,
  contract,
  provider,
  walletAddress,
  setShowAlert,
  setUpdateGameData,
}) => {
  const gameStartedEventFilter = contract.filters.GameStarted();
  AddNewEvent(gameStartedEventFilter, provider, ({ args }) => {
    console.log("New Game started!", args, walletAddress);

    if (
      walletAddress.toLowerCase() === args.player1.toLowerCase() ||
      walletAddress.toLowerCase() === args.player2.toLowerCase()
    ) {
      navigate(`/battle/${args._id}`);
    }

    setUpdateGameData((prevUpdateGameData) => prevUpdateGameData + 1);
  });
  ///--///--///--///--
  const gameHostedEventFilter = contract.filters.GameHosted();
  AddNewEvent(gameHostedEventFilter, provider, ({ args }) => {
    console.log("New Game Hosted!", args);
  });
  ///--///--///--///--
  const gameCompletedEventFilter = contract.filters.GameCompleted();
  AddNewEvent(gameCompletedEventFilter, provider, ({ args }) => {
    console.log("Battle ended!", args, walletAddress);

    if (walletAddress.toLowerCase() === args.winner.toLowerCase()) {
      setShowAlert({
        status: true,
        type: "success",
        msg: "You won the battle!",
      });
    } else if (walletAddress.toLowerCase() === args.loser.toLowerCase()) {
      setShowAlert({
        status: true,
        type: "failure",
        msg: "You lost the battle!",
      });
    }

    navigate("/create-battle");
  });
};
