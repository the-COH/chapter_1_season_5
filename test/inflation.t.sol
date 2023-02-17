// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";

// import "../src/interfaces/IMember1155.sol";
// import "../src/interfaces/iInstanceDAO.sol";
// import "../src/interfaces/IDAO20.sol";
// import "../src/interfaces/IERC721.sol";

// import "../src/oDAO.sol";
// import "../src/Member1155.sol";
// import "./mocks/mockERC20.sol";

// import {Turnstile} from "../../src/utils/CantoTurnslide.sol";

// contract redistributiveInflation is Test {
//     IoDAO O;
//     IERC20 BaseE20;
//     IMemberRegistry iMR;
//     IMembrane iMB;
//     DAOinstance DAO;

//     address deployer = address(4896);
//     address Agent1 = address(16);
//     address Agent2 = address(32);
//     address Agent3 = address(48);

//     function setUp() public {
//         vm.prank(deployer, deployer);
//         BaseE20 = IERC20(address(new M20()));
//                         address mainnetTurnslideAddr = address( new Turnstile() );

//         iMR = IMemberRegistry(address(new MemberRegistry(mainnetTurnslideAddr)));
//         iMB = IMembrane(iMR.MembraneRegistryAddress());
//         O = IoDAO(iMR.ODAOaddress());
//     }

//     function _createAnERC20() public returns (address) {
//         return address(new M20());
//     }

//     function _createBasicMembrane(uint256 skipSeconds) public returns (uint256 basicMid) {
//         address[] memory tokens_ = new address[](1);
//         uint256[] memory balances_ = new uint[](1);

//         tokens_[0] = address(BaseE20);
//         balances_[0] = uint256(1000);
//         skip(skipSeconds);
//         basicMid = iMB.createMembrane(tokens_, balances_, "much membraneeeeeeeeeeeeeeeeeeee");
//     }

//     function _membraneContext() public {
//         vm.prank(deployer, deployer);
//         address dInstance = address(O.createDAO(address(BaseE20)));
//         DAO = DAOinstance(dInstance);

//         /// active membrane of dInstance
//         uint256 currentMembrane;

//         currentMembrane = iMB.inUseMembraneId(dInstance);
//         assertTrue(currentMembrane == 0, "has unexpected default membrane");

//         address[] memory a = new address[](1);
//         uint256[] memory u = new uint[](1);

//         a[0] = DAO.baseTokenAddress();
//         u[0] = 101_000;
//         uint256 membrane1 = iMB.createMembrane(a, u, "url://deployer_hasaccessmeta");

//         vm.prank(dInstance);
//         iMB.setMembrane(membrane1, dInstance);

//         assertTrue((iMB.inUseMembraneId(dInstance) == membrane1), "failed to set");
//     }

//     //// #######################################

//     function testMintsInflation() public {
//         _membraneContext();
//         uint256 startInflation = DAO.baseInflationRate();
//         uint256 startPerSec = DAO.baseInflationPerSec();
//         IERC20 internalT = IERC20(DAO.internalToken());
//         IERC20 baseT = IERC20(DAO.baseTokenAddress());

//         assertTrue(startInflation == (DAO.baseID() % 100), "unexpected start % infl");
//         assertTrue(startPerSec == 0, "not 0");
//         assertTrue(iMR.balanceOf(Agent1, DAO.baseID()) == 0, "agent1 already member");
//         assertTrue(DAO.mintMembershipToken(Agent1), "mint failed");

//         assertTrue(internalT.balanceOf(Agent1) == 0, "has internal balance");
//         vm.startPrank(Agent1);
//         assertTrue(baseT.approve(address(DAO), type(uint256).max), "approve f");

//         baseT.approve(address(internalT), 100000000 * 1 ether);
//         IDAO20(DAO.internalTokenAddress()).wrapMint(10 * 1 ether);
//         assertTrue(internalT.balanceOf(Agent1) != 0, "does not have internal balance");

//         uint256 newInflation = DAO.signalInflation(2);
//         assertTrue(newInflation == DAO.baseInflationRate(), "unexpected inflation");
//         vm.stopPrank();

//         assertTrue(startInflation != DAO.baseInflationRate(), "samo1");
//         assertTrue(startPerSec != DAO.baseInflationPerSec(), "samo2");

//         skip(2000);

//         uint256 minted = DAO.mintInflation();
//         uint256 basePerSec1 = DAO.baseInflationPerSec();
//         assertTrue(minted < (DAO.baseInflationPerSec() * 2000), "math went wrong");
//         /// @dev todo calculate match rise in basePerSec given increase in totalSupply

//         skip(3000);
//         minted += DAO.mintInflation();
//         uint256 basePerSec2 = DAO.baseInflationPerSec();
//         assertTrue(minted < (DAO.baseInflationPerSec() * 5000), "math went wrong");

//         skip(1);
//         minted = DAO.mintInflation();
//         uint256 basePerSec3 = DAO.baseInflationPerSec();

//         assertTrue(basePerSec3 > basePerSec2, "inflation per sec should rise with supply");
//         assertTrue(basePerSec2 > basePerSec1, "inflation per sec should rise with supply");
//     }
// }
