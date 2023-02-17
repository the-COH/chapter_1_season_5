// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./utils/functionality.t.sol";
import "../src/ExternalCall.sol";
import "./mocks/ExtCallBoolMock.sol";

contract ExtCallT is Test, MyUtils {
    iInstanceDAO DAO;
    IDAO20 internalT;
    IERC20 baseT;
    MExtCallBool mockExternalContractToCall;

    constructor() {
        baseT = IERC20(new M20());
        mockExternalContractToCall = new MExtCallBool();
    }

    function setUp() public {
        vm.prank(Agent1);
        DAO = iInstanceDAO(_createDAO(address(baseT)));
        vm.startPrank(Agent2);
        DAO.mintMembershipToken(Agent2);
        DAO.mintMembershipToken(Agent3);
        internalT = IDAO20(DAO.internalTokenAddress());
        baseT = IERC20(DAO.baseTokenAddress());
        baseT.approve(address(internalT), type(uint256).max);
        internalT.wrapMint(1000 ether);
        vm.stopPrank();

        _setCreateMembrane(address(DAO));
    }

    function testCheckDeployed() public {
        ExtCall memory extCall = iEXTcall.getExternalCallbyID(1);
        assertTrue(
            extCall.dataToCallWith.length + extCall.dataToCallWith.length + bytes(extCall.shortDescription).length == 0,
            "unxepected default length"
        );
    }

    function testnewExtCall() public {
        uint256 extCid = _createMockExternalCall();
        ExtCall memory E = iEXTcall.getExternalCallbyID(extCid);
        string memory expectedString = "default description text";
        assertTrue(
            uint256(keccak256(abi.encode(E.shortDescription))) == uint256(keccak256(abi.encode(expectedString))),
            "unexpected description"
        );
        assertTrue(extCid == uint256(keccak256(abi.encode(E))) % 1 ether, "unexpected sum");
    }

    function testChangeExternalCall() public {
        address[] memory contracts = new address[](1);
        bytes[] memory callDs = new bytes[](1);

        contracts[0] = address(mockExternalContractToCall);
        callDs[0] = abi.encodePacked(mockExternalContractToCall.flipSwitch.selector);

        uint256 extCid = _createExternalCall(contracts, callDs, "1010101010101010101 test executes externall call");

        vm.startPrank(Agent2);

        assertTrue(!mockExternalContractToCall.getSwitchStateOf(address(DAO)), "expected false");

        uint256 exeReturns = DAO.executeCall(extCid);
        skip(11 * 1 days);
        exeReturns = DAO.executeCall(extCid);

        assertTrue(exeReturns == extCid, "expected callID to be returned on successful exec");

        assertTrue(mockExternalContractToCall.getSwitchStateOf(address(DAO)), "expected true");

        vm.stopPrank();

        vm.prank(address(44));
        vm.expectRevert();
        DAO.executeCall(extCid);

        vm.prank(Agent3);
        exeReturns = DAO.executeCall(extCid);
        assertTrue(exeReturns == 0, "non-majoritarian call");
    }
}
