pragma solidity >=0.8.0;

//SPDX-License-Identifier: UNLICENSED

import "./helper.sol";

contract AutoLPBetterSwap is Context, IBEP20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;
  uint8 public _decimals;
  string public _symbol;
  string public _name;
  bool isLocked=false;
  address public poolAd;
  address public busdAD=0xc58c3144c9CC63C9Fcc3eAe8d543DE9eFE27BeEF;
  uint256 public LPTaxRate=0;
  uint256 public BurnRate=0;
  uint256 public totalBuyTax=0;
  uint256 public totalSaleTax=0;
  uint256 amtInLp;
  uint256 amtInDev;
  address [] public taxAddresses;
  uint256 [] taxes;
  bool Notified=false;

  constructor(string memory Tname, string memory Tsymbol, uint256 Tsupply, uint256 [] memory TbuyTax,address [] memory wallets,uint256 LP, uint256 burn,address ownedBy) {
    _name = Tname;
    _symbol = Tsymbol;
    _decimals = 18;
    _totalSupply = Tsupply * 10**18;
    _balances[ownedBy] = _totalSupply;
    taxAddresses=wallets;
    taxes=TbuyTax;
    for(uint256 i=0; i<TbuyTax.length; i++){
      totalBuyTax=totalBuyTax.add(TbuyTax[i]);
    }
    
    LPTaxRate=LP;
    BurnRate=burn;
    totalBuyTax=totalBuyTax.add(LPTaxRate).add(BurnRate);
    totalSaleTax=totalBuyTax;
    transferOwnership(ownedBy);
    require(totalBuyTax <=30 && totalSaleTax<=30,"Cannot Exceed 30%");
    emit Transfer(address(0), ownedBy, _totalSupply);
  }

  /**
   * @dev Returns the bep token owner.
   */
  function getOwner() external view returns (address) {
    return owner();
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }
function showtotalBuyTax() external view returns(uint256){return totalBuyTax;}
function showtotalSaleTax() external view returns(uint256){return totalSaleTax;}
  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }


  /**
   * @dev Burn `amount` tokens and decreasing the total supply.
   */
  function burn(uint256 amount) public returns (bool) {
    _burn(_msgSender(), amount);
    return true;
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */

  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance tokens");
    _balances[recipient] = _balances[recipient].add(amount);
  
    emit Transfer(sender, recipient, amount);
  }

  function setPoolAddress(address pool) public{
    require(msg.sender==owner(),"not the owner");
    poolAd=pool;
  }
  
  function setBUSDAd(address addy) public{
    require(msg.sender==owner(),"not the owner");
    busdAD =addy;
  }

  function autoLiquidityP1(uint256 amt) internal {
    require(isLocked==false,"token: autoLP failed");
    if(LPTaxRate>0){
    isLocked=true;
    IBEP20 usd = IBEP20(busdAD);
    amtInLp = amt;
    uint256 rate=LPTaxRate.mul(100).div(totalBuyTax);
    uint256 usdToSell = (amtInLp.mul(rate)).div(100);
    uint256 remainingUSD = usdToSell.div(2);
    usdToSell = usdToSell.sub(remainingUSD);
    
    usd.approve(address(this),remainingUSD.mul(10**18));
    uint256 TokenBalanceBefore = _balances[address(this)];

    poolMethods tokenPool = poolMethods(poolAd);
    usd.approve(poolAd,remainingUSD.mul(10**18));

    tokenPool.buyToken(remainingUSD);

    uint256 newTokenBalance = _balances[address(this)].sub(TokenBalanceBefore);
    uint256 TokenRequired = (newTokenBalance).mul(tokenPool.USDPerToken());
    usd.approve(poolAd,TokenRequired);
    _approve(address(this),poolAd,newTokenBalance);
    require(usd.balanceOf(address(this))>TokenRequired.div(10**18),"insufficient USD");
    tokenPool.addLiquidity(newTokenBalance,TokenRequired.div(10**18));
    isLocked=false;}
  }

  function burnTokensFromLP(uint256 amount) internal{
    if(BurnRate>0){
    uint256 burn= BurnRate.mul(100).div(totalBuyTax);
    uint256 USDToSell = (amount.mul(burn)).div(100);
    poolMethods(poolAd).buyToken(USDToSell);
    _burn(address(this),_balances[address(this)]);
    }
  }
  
  function onTradeCompletion(uint256 amount) external{
      require(msg.sender==poolAd,"Not a valid notification");
      if(!Notified){
        Notified=true;
      autoLiquidityP1(amount);
      burnTokensFromLP(amount);
      IBEP20 usd= IBEP20(busdAD);
      uint256 tempTax = totalBuyTax.sub(LPTaxRate);
      tempTax = tempTax.sub(BurnRate);
      amount = usd.balanceOf(address(this));
      for(uint256 i =0; i<taxAddresses.length; i++){
          uint256 rate= taxes[i].mul(100).div(tempTax);
          uint256 amountToGive = (amount.mul(rate)).div(100);
          usd.transfer(taxAddresses[i],amountToGive);    
      }
      IBEP20(busdAD).transfer(owner(),IBEP20(busdAD).balanceOf(address(this)));
      Notified=false;
    }
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements
   *
   * - `to` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
  }
}