// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

// import openzeppelin contracts
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Driger is ERC20, Ownable, Pausable {
    
    /** @notice Creates ERC20 token
    name: Driger
    symbol: DRI
    totalsupply = 100000000 * 10**18
    */
    constructor() ERC20("Driger", "DRIG") onlyOwner{
        _mint(msg.sender, 100000000 * 10**18);
    }

    /// @notice Pause the contract
    /// @dev circuit breaker pattern
    function pause() public onlyOwner{
        Pausable._pause();
    }

    /// @notice Unpause the contract
    /// @dev circuit breaker pattern
    function unpause() public onlyOwner {
        Pausable._unpause();
    }
}