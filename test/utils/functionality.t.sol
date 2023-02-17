pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../../src/interfaces/IMember1155.sol";
import "../../src/interfaces/iInstanceDAO.sol";
import "../../src/interfaces/IDAO20.sol";
import "../../src/interfaces/IMembrane.sol";
import "../../src/interfaces/IExternalCall.sol";

import "../../src/Member1155.sol";
import "../mocks/mockERC20.sol";

import {WlW} from "../../src/WLW.sol";
import {IWLW20} from "../../src/interfaces/IWLW20.sol";
import {Turnstile} from "../../src/utils/CantoTurnslide.sol";
import {CSRvault} from "../../src/CSRVault.sol";

contract MyUtils is Test {
    IoDAO O;
    IERC20 BaseE20;
    IMemberRegistry iMR;
    IMembrane iMB;
    IExternalCall iEXTcall;
    IWLW20 WLWtoken;
    address CSRv;

    address deployer = address(4896);
    address Agent1 = address(16);
    address Agent2 = address(32);
    address Agent3 = address(48);

    constructor() {
        address mainnetTurnslideAddr = address(new Turnstile());
        WLWtoken = IWLW20(address(new WlW()));
        CSRv = address(new CSRvault(address(WLWtoken), mainnetTurnslideAddr ));
        vm.prank(deployer, deployer);
        iMR = IMemberRegistry(address(new MemberRegistry(CSRv)));
        O = IoDAO(iMR.ODAOaddress());
        iMB = IMembrane(iMR.MembraneRegistryAddress());
        BaseE20 = IERC20(address(new M20()));
        iEXTcall = IExternalCall(iMR.ExternalCallAddress());
    }

    function _createAnERC20() public returns (address) {
        return address(new M20());
    }

    function _createDAO(address _baseToken) public returns (address DAO) {
        return address(O.createDAO(address(_baseToken)));
    }

    function _createBasicMembrane() public returns (uint256 basicMid) {
        address[] memory tokens_ = new address[](1);
        uint256[] memory balances_ = new uint[](1);

        tokens_[0] = address(BaseE20);
        balances_[0] = uint256(1000);
        basicMid = iMB.createMembrane(tokens_, balances_, "l0l.wAllAw.l0l");
    }

    function _setInflation(uint256 percent_, address _DAOaddr) public {
        vm.prank(Agent1);
        iInstanceDAO(_DAOaddr).signalInflation(percent_);
    }

    function _createSubDaos(uint256 howMany_, address parentDAO_) public returns (address[] memory subDs) {
        uint256 basicMembrane = _createBasicMembrane();
        uint256 i;
        for (i; i < howMany_;) {
            O.createSubDAO(basicMembrane, parentDAO_);
            unchecked {
                ++i;
            }
        }

        subDs = O.getDAOsOfToken(iInstanceDAO(parentDAO_).internalTokenAddress());
    }

    function _createNestedDAOs(address startDAO_, uint256 membrane, uint256 levels_)
        public
        returns (address[] memory nestedBaseIs0)
    {
        uint256 i;
        nestedBaseIs0 = new address[](levels_);
        nestedBaseIs0[i] = startDAO_;
        assertTrue(iMR.balanceOf(Agent1, iInstanceDAO(nestedBaseIs0[i]).baseID()) > 0, "not member");
        membrane = membrane == 0 ? _createBasicMembrane() : membrane;

        i = 1;
        for (i; i < levels_;) {
            nestedBaseIs0[i] = O.createSubDAO(membrane, nestedBaseIs0[i - 1]);
            unchecked {
                ++i;
            }
        }
    }

    function _setCreateMembrane(address DAO_) public {
        iInstanceDAO DAO = iInstanceDAO(DAO_);

        uint256 currentMembrane;

        currentMembrane = iMB.inUseMembraneId(DAO_);
        assertTrue(currentMembrane == 0, "has unexpected default membrane");

        address[] memory a = new address[](1);
        uint256[] memory u = new uint[](1);

        a[0] = DAO.baseTokenAddress();
        u[0] = 101_000;
        uint256 membrane1 = iMB.createMembrane(a, u, "l0l.wAllAw.l0l");

        vm.prank(DAO_);
        iMB.setMembrane(membrane1, DAO_);

        assertTrue((iMB.inUseMembraneId(DAO_) == membrane1), "failed to set");
    }

    function _setNewInflation(address DAO_, uint256 inflation_) public {
        iInstanceDAO DAO = iInstanceDAO(DAO_);
        uint256 initInflation = DAO.baseInflationRate();
        _setInflation(inflation_, address(DAO));
        uint256 initPerSec = DAO.baseInflationPerSec();

        if (initInflation == inflation_) _setInflation(inflation_, DAO_);
        assertFalse(initInflation == DAO.baseInflationRate(), "failed to update infaltion");
        assertTrue(initPerSec != 0, "per sec not updated");
    }

    function _createExternalCall(address[] memory contracts_, bytes[] memory callDatas_, string memory description_)
        public
        returns (uint256 createdId)
    {
        createdId = iEXTcall.createExternalCall(contracts_, callDatas_, description_);
    }

    function _createMockExternalCall() public returns (uint256 createdId) {
        address[] memory contracts = new address[](2);
        bytes[] memory calldatas = new bytes[](2);

        contracts[0] = address(123);
        contracts[1] = address(456);
        calldatas[0] = bytes("calldata1");
        calldatas[1] = bytes("calldata2");
        string memory description = "default description text";

        createdId = iEXTcall.createExternalCall(contracts, calldatas, description);
    }

    function testImportCheck() public {
        assertTrue(address(O) != address(0));
        assertTrue(address(BaseE20) != address(0));
        assertTrue(address(iMR) != address(0));
    }
}
