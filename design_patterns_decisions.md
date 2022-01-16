## Design Patterns

### Inheritance and Interfaces
Void.sol uses the IERC20 interface to interact with Drigers.sol ERC20 tokens  
### Access Control Design Patterns
onlyOwner
 - can mint Driger ERC20 tokens
 - can pause/unpause the Driger.sol contract
 - can allocate Driger ERC20 token to the contract to spend on their behalf
 - can pause/unpause the Void.sol contract
  
### Gas Optimizations
- Enabled gas optimization in truffle-config, used external instead of public functions where possible
- Declared external functions instead of public where possible