// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

//import openzeppeliin contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
/// @title The Void
/// @author Gio Keels 
/// @notice Contract allowing withdrawals, deposits, and rewards
*/

contract Void is Ownable, Pausable, ReentrancyGuard {
    IERC20 private driger;

    mapping (address => uint) private balances;
    mapping (address => uint) private timestamp;

    /// @notice listening of made deposit into The Void
    event LogWeiDeposit(address _accountAddress, uint _depositAmount);

    /// @notice listening of made withdrawl from The Void
    event LogWeiWithdrawal(address _accountAddress, uint _withdrawalAmount, uint _updatedBalance);

    /**
    @param _driger ERC20 token of contract
    @notice when Driger contract deployed, address of contract will
    be passed to the Void contract in order to use token.
    */
    constructor (IERC20 _driger) {
        driger = _driger;
    }

    /// @param _amountToWithdraw amount user wants to withdraw
    /// @notice user must have sufficient funds to withdraw
    modifier hasFunds(uint _amountToWithdraw) {
        require(balances[msg.sender] >= _amountToWithdraw, "Insufficient funds");
        _;
    }

    /// @param _user must have account with eth in The Void to receive reward token
    /// @param timestamp sets block timestamp to time of users first deposit to The Void
    /** @notice when in full production, user must leave deposit in for Void for >= 333 days 
        @notice for testing purpose only, user will receive reward right away with requirement
    */
    modifier isHodler(address _user) {
        require((timestamp[_user]- 1 days) < block.timestamp, "Hasn't held funds long enough");
        _;
    }
    /// @dev when in production delete the modifier of line 48 and uncomment modifier line below
    /** modifier isHodler(address _user){
            require((timestamp[_user] + 365 days) >= block.timestamp, "Hasn't held funds longer than 1 year");
            _;
        } */

    /// @notice made deposit into The Void
    function deposit() external payable nonReentrant {
        require(msg.value > 0, "Must deposit at least 1 wei");
        /// @notice HODL time logged att current block.timestamp
        if(timestamp[msg.sender] == 0 && balances[msg.sender] == 0){
            timestamp[msg.sender] = block.timestamp;
        }
    
        /// @notice updates users balance in account
        balances[msg.sender] += msg.value;

        /// @notice emits log of deposit
        emit LogWeiDeposit(msg.sender, msg.value);
    }

    /// @param _amountToWithdraw amount user wants to withdraw
    /// @notice must have sufficient funds in account to withdraw
    function withdraw(uint _amountToWithdraw) external payable hasFunds(_amountToWithdraw) nonReentrant {
        address payable _user = payable(msg.sender);

        /// @notice withdrawal amount taken from users Void balance
        balances[msg.sender] -= _amountToWithdraw;

        /// @notice timestamp set to 0 once withdrawn liquidity
        timestamp[msg.sender] = 0;

        /// @notice withdrawal amount is transferred to users EOA
        (bool success, ) = _user.call{value:_amountToWithdraw}("");
        require(success, "Transfer Failed");
        
        /// @notice emits log of withdrawal
        emit LogWeiWithdrawal(msg.sender, _amountToWithdraw, balances[msg.sender]);
    }

    
    /// @notice only owner of ERC20 contract can approve this contract to spend its tokens
    function transferDrigersToContract(uint _amountToContractInDrigers) external onlyOwner{
        address from = msg.sender;

        /// @notice transfers Driger ERC20 token from owner to Void contract
        driger.transferFrom(from, address(this), _amountToContractInDrigers);
    }

    /// @notice rewards liquidity providers with Driger tokens if Hodl deposit in Void
    function mintDrigersToUser(address _user) public isHodler(_user) nonReentrant{
        require(driger.balanceOf(_user) == 0, "User already claimed rewards");

        /// @notice transfer 1000 Driger tokens to hodler of account
        driger.transfer(_user, 1000 * 10**18);

        /// @notice timestamp for user reset to 0 once rewards claimed
        timestamp[_user] = 0;
    }

    /// @notice get wei balance in users account
    /// @return returns uint
    function getWeiBalance() external view returns(uint) {
        return balances[msg.sender];
    }

    /// @notice get timestamp for users liquidity providing duration
    /// @return returns uint
    function getTimestamp() external view returns(uint) {
        return timestamp[msg.sender];
    }

    /// @notice pause the contract
    /// @dev circuit breaker pattern
    function pause() public onlyOwner {
        Pausable._pause();
    }

    /// @notice unpauses the contract
    /// @dev circuit breaker pattern
    function unpause() public onlyOwner {
        Pausable._unpause();
    }
}
