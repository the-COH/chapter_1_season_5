// SPDX-License-Identifier: MIT

//                         /-\~!!!!!/}
//                   /-XUHWH!! !!?M88WHX-/
//                 /-X#@$!!  !X!@$$$$$$WWX-/
//                /-!!!!!?H! :!$!$$$$$$$$$$8X-/
//               !!-  -:~!! :~!$!#$$$$$$$$$$8X-/
//              :!-::!H!<   -.U$X!?R$$$$$$$$MM!
//              ~!-!!!!!-- .:XW$$$U!!?$$$$$$RMM!
//                !:~~~ .:!M*T#$$$$WX??#MRRMMM!
//                ~?WuxiW*`   `*#$$$$8!!!!??!!!
//              X- M$$$$       `*T#$T~!8$WUXU~
//             %`  ~#$$$m:        ~!~ ?$$$$$$
//           !`.-   ~T$$$$8xx.  .xWW- ~**##**
// .....   -~~>` !    ~?T#$$@@W@*?$$      \`
// W@@M!!! .!~~ !!     :XUW$W!~ `*~:    :
// #*~~`:%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
// /-~:!!`X- .: ?H.!u *$$$B$$$!W:U!T$$M~
// .~~   X@!.-~   ?@WTWo(**$$$W$TH$! `
// Wi.~!X$?!-~    : ?$$$B$Wu(***$RM!
// @R@i.~~ !     :   ~$$$$$B$$en:``
// ?MXT@WX.~    :     ~*##*$$$$M~
// ?XTB@W.    :         ~$$$**
// XXB!!.   :



pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol";

contract CypherSkulls is
  ERC721A,
  Ownable,
  ReentrancyGuard,
  DefaultOperatorFilterer
{
  string public baseURI;
  uint256 public cost = 0.01 ether;
  uint256 public wlcost = 0 ether;
  uint256 public maxSupply = 1337;
  uint256 public WlSupply = 333;
  uint256 public MaxperWallet = 100;
  uint256 public MaxperWalletWl = 1;
  bool public paused = true;
  bool public preSale = true;
  bytes32 public merkleRoot;
  mapping(address => uint256) public PublicMintofUser;
  mapping(address => uint256) public WhitelistedMintofUser;
  mapping(uint256 => uint256) public basedScore;
  mapping(uint256 => uint256) public shieldScore;
  mapping(uint256 => bool) public cig;
  mapping(uint256 => bool) public screaming;
  mapping(uint256 => string) public vibe;

  constructor(string memory _initBaseURI) ERC721A("Cypher Skulls", "SKULL") {
    setBaseURI(_initBaseURI);
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }

  function getBasedScore(uint256 _id) public view returns (uint256) {
    return basedScore[_id];
  }

  function getShieldScore(uint256 _id) public view returns (uint256) {
    return shieldScore[_id];
  }

  function getCig(uint256 _id) public view returns (bool) {
    return cig[_id];
  }

  function getScreaming(uint256 _id) public view returns (bool) {
    return screaming[_id];
  }

  function getVibe(uint256 _id) public view returns (string memory) {
    return vibe[_id];
  }

  // public
  /// @dev Public mint
  function mint(uint256 tokens) public payable nonReentrant {
    require(!paused, "SYMBOL: oops contract is paused");
    require(!preSale, "SYMBOL: Sale Hasn't started yet");
    require(tokens <= MaxperWallet, "SYMBOL: max mint amount per tx exceeded");
    require(totalSupply() + tokens <= maxSupply, "SYMBOL: We Soldout");
    require(
      PublicMintofUser[_msgSenderERC721A()] + tokens <= MaxperWallet,
      "SYMBOL: Max NFT Per Wallet exceeded"
    );
    require(msg.value >= cost * tokens, "SYMBOL: insufficient funds");

    PublicMintofUser[_msgSenderERC721A()] += tokens;
    _safeMint(_msgSenderERC721A(), tokens);
  }

  /// @dev presale mint for whitelisted
  function presalemint(uint256 tokens, bytes32[] calldata merkleProof)
    public
    payable
    nonReentrant
  {
    require(!paused, "SYMBOL: oops contract is paused");
    require(preSale, "SYMBOL: Presale Hasn't started yet");
    require(
      MerkleProof.verify(
        merkleProof,
        merkleRoot,
        keccak256(abi.encodePacked(msg.sender))
      ),
      "SYMBOL: You are not Whitelisted"
    );
    require(
      WhitelistedMintofUser[_msgSenderERC721A()] + tokens <= MaxperWalletWl,
      "SYMBOL: Max NFT Per Wallet exceeded"
    );
    require(tokens <= MaxperWalletWl, "SYMBOL: max mint per Tx exceeded");
    require(
      totalSupply() + tokens <= WlSupply,
      "SYMBOL: Whitelist MaxSupply exceeded"
    );
    require(msg.value >= wlcost * tokens, "SYMBOL: insufficient funds");

    WhitelistedMintofUser[_msgSenderERC721A()] += tokens;
    _safeMint(_msgSenderERC721A(), tokens);
  }

  /// @dev use it for giveaway and team mint
  function airdrop(uint256 _mintAmount, address destination)
    public
    onlyOwner
    nonReentrant
  {
    require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");

    _safeMint(destination, _mintAmount);
  }

  /// @notice returns metadata link of tokenid
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721AMetadata: URI query for nonexistent token"
    );

    string memory currentBaseURI = _baseURI();
    return
      bytes(currentBaseURI).length > 0
        ? string(
          abi.encodePacked(
            currentBaseURI,
            "cypherSkull_",
            _toString(tokenId),
            ".json"
          )
        )
        : "";
  }

  /// @notice return the number minted by an address
  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  /// @notice return the tokens owned by an address
  function tokensOfOwner(address owner) public view returns (uint256[] memory) {
    unchecked {
      uint256 tokenIdsIdx;
      address currOwnershipAddr;
      uint256 tokenIdsLength = balanceOf(owner);
      uint256[] memory tokenIds = new uint256[](tokenIdsLength);
      TokenOwnership memory ownership;
      for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
        ownership = _ownershipAt(i);
        if (ownership.burned) {
          continue;
        }
        if (ownership.addr != address(0)) {
          currOwnershipAddr = ownership.addr;
        }
        if (currOwnershipAddr == owner) {
          tokenIds[tokenIdsIdx++] = i;
        }
      }
      return tokenIds;
    }
  }

  /// @dev change the merkle root for the whitelist phase
  function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
    merkleRoot = _merkleRoot;
  }

  /// @dev change the public max per wallet
  function setMaxPerWallet(uint256 _limit) public onlyOwner {
    MaxperWallet = _limit;
  }

  /// @dev change the whitelist max per wallet
  function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
    MaxperWalletWl = _limit;
  }

  /// @dev change the public price(amount need to be in wei)
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  /// @dev change the whitelist price(amount need to be in wei)
  function setWlCost(uint256 _newWlCost) public onlyOwner {
    wlcost = _newWlCost;
  }

  /// @dev cut the supply if we dont sold out
  function setMaxsupply(uint256 _newsupply) public onlyOwner {
    maxSupply = _newsupply;
  }

  /// @dev cut the whitelist supply if we dont sold out
  function setwlsupply(uint256 _newsupply) public onlyOwner {
    WlSupply = _newsupply;
  }

  /// @dev set your baseuri
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }


  function setBasedScore(uint256[] memory _basedScore) public onlyOwner {
    for (uint256 i = 0; i < _basedScore.length; i++) {
      basedScore[i+1] = _basedScore[i];
    }
  }
  function setShieldScore(uint256[] memory _shieldScore) public onlyOwner {
    for (uint256 i = 0; i < _shieldScore.length; i++) {
      shieldScore[i+1] = _shieldScore[i];
    }
  }
  function setCig(bool[] memory _cig) public onlyOwner {
    for (uint256 i = 0; i < _cig.length; i++) {
      cig[i+1] = _cig[i];
    }
  }
  function setScreaming(bool[] memory _screaming) public onlyOwner {
    for (uint256 i = 0; i < _screaming.length; i++) {
      screaming[i+1] = _screaming[i];
    }
  }
  
  function setVibe(string[] memory _vibe) public onlyOwner {
    for (uint256 i = 0; i < _vibe.length; i++) {
      vibe[i+1] = _vibe[i];
    }
  }


  /// @dev to pause and unpause your contract(use booleans true or false)
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }

  /// @dev activate whitelist sale(use booleans true or false)
  function togglepreSale(bool _state) external onlyOwner {
    preSale = _state;
  }

  /// @dev withdraw funds from contract
  function withdraw() public payable onlyOwner nonReentrant {
    uint256 balance = address(this).balance;
    payable(_msgSenderERC721A()).transfer(balance);
  }

  /// Opensea Royalties

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public payable override onlyAllowedOperator(from) {
    super.transferFrom(from, to, tokenId);
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) public payable override onlyAllowedOperator(from) {
    super.safeTransferFrom(from, to, tokenId);
  }

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public payable override onlyAllowedOperator(from) {
    super.safeTransferFrom(from, to, tokenId, data);
  }
}


//      _______. __  ___  __    __   __       __           _______      ___      .___  ___.  _______
//     /       ||  |/  / |  |  |  | |  |     |  |         /  _____|    /   \     |   \/   | |   ____|
//    |   (----`|  '  /  |  |  |  | |  |     |  |        |  |  __     /  ^  \    |  \  /  | |  |__
//     \   \    |    <   |  |  |  | |  |     |  |        |  | |_ |   /  /_\  \   |  |\/|  | |   __|
// .----)   |   |  .  \  |  `--'  | |  `----.|  `----.   |  |__| |  /  _____  \  |  |  |  | |  |____
// |_______/    |__|\__\  \______/  |_______||_______|    \______| /__/     \__\ |__|  |__| |_______|
// by: 6e61.eth & txcc

contract CypherSkullsGame is Ownable{
  
  uint256 gameNumber;
  bool paused = true;
  uint256 nonce;

  enum BattleStatus {
    PENDING,
    STARTED,
    ENDED
  }

  struct ActiveGame {
    BattleStatus battleStatus;
    uint256 id;
    uint256 value;
    address[2] players;
    uint256[2] tokenIDs;
    address winner;
  }

  // Player[] public players; // Array of players
  ActiveGame[] public activeGames;
  CypherSkulls internal cypherSkull;

  // Wins per player, can be cleared on new season
  mapping(address => uint256) public playerWins;
  uint256 public season;
  address[] public playerList;


  // Events
  event GameHosted(uint256 indexed _id, address indexed player1);
  event GameStarted(uint256 indexed _id, address indexed player1, address indexed player2);
  event GameCompleted(uint256 indexed _id, address indexed winner);

  // If player already hosting game
  mapping(address => bool) hostingGame;

  constructor(address _importedContractAddress) {
    cypherSkull = CypherSkulls(_importedContractAddress);
    initialize();
  }

  // initialize game
  function initialize() private {
    gameNumber = 0;
    season = 1;
    nonce = 1;
    activeGames.push(
      ActiveGame(
        BattleStatus.PENDING,
        gameNumber,
        0,
        [address(0), address(0)],
        [uint256(0), uint256(0)],
        address(0)
      )
    );
    gameNumber++;
  }

  // Begin new Skull Card game
  // Param: CypherSkull tokenID
  function startGame(uint256 _tokenId) public payable {
    // Game start requirements
    require(
      msg.value == 0.01 ether ||
      msg.value == 5 ether ||
        msg.value == 25 ether ||
        msg.value == 50 ether ||
        msg.value == 100 ether,
      "Invalid entry cost"
    );
    require(!hostingGame[msg.sender], "Already hosting a game.");
    require(
      cypherSkull.ownerOf(_tokenId) == msg.sender,
      "You must hold the skull you are want to play with"
    );
    require(!paused, "Game is Paused by Owner");

    // Assign active game variables
    uint256 _gameId = gameNumber;
    uint256 _value = msg.value;

    _addGame(_gameId, _tokenId, _value);
    addPlayer(msg.sender);
  }

  // Add new active game
  function _addGame(
    uint256 _gameId,
    uint256 _tokenId,
    uint256 _value
  ) internal {
     ActiveGame memory newGame = ActiveGame(
      BattleStatus.PENDING, // Battle pending
      _gameId, // Game ID
      _value, // Value of Game
      [msg.sender, address(0)], // player addresses; player 2 empty until they joins battle
      [_tokenId, 0], // CypherSkull toke ID's
      address(0) // winner address; empty until battle ends,
    );
    activeGames.push(newGame);

    // Set sender as active host
    hostingGame[msg.sender] = true;

    gameNumber++;
    emit GameHosted(_gameId, msg.sender);
  }

  // Deactivate the game
  function payoutAll() public onlyOwner {
    for (uint256 i = 0; i < activeGames.length; i++) {
      if (activeGames[i].battleStatus == BattleStatus.PENDING) {
        address payable recipient = payable(activeGames[i].players[0]);
        recipient.transfer(activeGames[i].value);
        activeGames[i].battleStatus = BattleStatus.ENDED;
      }
    }
  }

  function joinGame(
    uint256 _gameId,
    uint256 _tokenId
  ) external payable returns (ActiveGame memory) {
    // Game start requirements
    require(msg.value == activeGames[_gameId].value, "Invalid entry cost");
    require(activeGames[_gameId].players[0] != msg.sender, "Cant play against yourself");
    require(
      cypherSkull.ownerOf(_tokenId) == msg.sender,
      "You must hold the skull you are want to play with"
    );

    require(
      activeGames[_gameId].battleStatus == BattleStatus.PENDING,
      "Battle already started!"
    ); // Require that battle has not started
    require(!paused, "Game is puased by Owner");

    ActiveGame memory currentGame = getActiveGame(_gameId);

    currentGame.battleStatus = BattleStatus.STARTED;
    currentGame.players[1] = msg.sender;
    currentGame.tokenIDs[1] = _tokenId;

    addPlayer(msg.sender);

    emit GameStarted(_gameId, currentGame.players[0], currentGame.players[1]);
    _resolveBattle(currentGame);
    return currentGame;
  }


  function _resolveBattle(ActiveGame memory currentGame) internal {
    
    bool p1cig = cypherSkull.getCig(currentGame.tokenIDs[0]);
    bool p1scream = cypherSkull.getScreaming(currentGame.tokenIDs[0]);
    uint256 p1score = cypherSkull.getBasedScore(currentGame.tokenIDs[0]);
    uint256 p1shield = cypherSkull.getShieldScore(currentGame.tokenIDs[0]);

    bool p2cig = cypherSkull.getCig(currentGame.tokenIDs[1]);
    bool p2scream = cypherSkull.getScreaming(currentGame.tokenIDs[1]);
    uint256 p2score = cypherSkull.getBasedScore(currentGame.tokenIDs[1]);
    uint256 p2shield = cypherSkull.getShieldScore(currentGame.tokenIDs[1]);

    bool outcome = _determineWinner(
      p1cig,
      p1scream,
      p1score,
      p1shield,
      p2cig,
      p2scream,
      p2score,
      p2shield
    );

    if (outcome){
      currentGame.winner = currentGame.players[0];
    } else {
      currentGame.winner = currentGame.players[1];
    }
    _payout(currentGame);
  }

  function _determineWinner(
    bool p1cig,
    bool p1scream,
    uint256 p1score,
    uint256 p1shield,
    bool p2cig,
    bool p2scream,
    uint256 p2score,
    uint256 p2shield
  ) internal returns (bool) {

    // Intrinsic 50% win chance
    uint256 p1Odds = 50;
    uint256 p2Odds = 50;

    // Add a 10 point boost for cigs
    if (p1cig) {
      p1Odds += 10;
    }
    if (p2cig) {
      p2Odds += 10;
    }

    // Add a 10 point boost for scream
    if (p1scream) {
      p1Odds += 10;
    }
    if (p2scream) {
      p2Odds += 10;
    }

    // Minus a 10 points from enemy for shield
    // Incorporate based score
    uint256 player1AdjustedScore = p1Odds - (p2shield / 6);
    uint256 player2AdjustedScore = p2Odds - (p1shield / 6);
    
    // Incorporate based score
    player1AdjustedScore = p1Odds + (p1score / 5);
    player2AdjustedScore = p2Odds + (p2score / 5);

    uint256 totalScore = player1AdjustedScore + player2AdjustedScore;
    uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % totalScore;
    nonce++;
    return randomNumber < player1AdjustedScore; //true player 1 wins, false player 2 wins
  }

  function _payout(
    ActiveGame memory currentGame
  ) internal {
    address payable recipientPayee = payable(currentGame.winner);
    recipientPayee.transfer(currentGame.value*2);
    playerWins[currentGame.winner] += 1;
    emit GameCompleted(currentGame.id, currentGame.winner);

  }

  function getActiveGame(uint256 _gameId) public view returns(ActiveGame memory){
    return activeGames[_gameId];
  }

  function getActiveGames() public view returns(ActiveGame[] memory){
    return activeGames;
  }

  //Update season
  function updateSeason() public onlyOwner returns(bool){
    for (uint256 i=0; i<playerList.length; i++) {
        playerWins[playerList[i]] = 0;
    }
    season += 1;
    return true;
  }

  function addPlayer(address newAddress) public {
        bool found = false;
        for (uint i = 0; i < playerList.length; i++) {
            if (playerList[i] == newAddress) {
                found = true;
                break;
            }
        }
        if (!found) {
            playerList.push(newAddress);
        }
    }

    function getPlayerList() public view returns (address[] memory) {
        return playerList;
    }

}