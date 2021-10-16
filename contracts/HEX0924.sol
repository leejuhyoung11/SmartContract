// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract HEX0924 {
    string public constant name = "HEX0924";
    string public constant symbol = "HEXTEXT";
    uint256 public constant init_amount = 10**5;
    uint256 public total_amount;
    
    address public owner_address; // owner of HEX0924 contract
    address public owner; // owner of proxy contract
    address public implementation;
    
    
    mapping (address => uint) public balance;
    
    event Received(address, uint);
    
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor () {
        owner_address = msg.sender;
        total_amount = init_amount;
        balance[owner_address] = total_amount;
        owner = msg.sender;
    }
    
    function getOwner() external view returns (address) {
        return owner_address;
    }
    
    function getImplementation() external view returns (address) {
        return implementation;
    }
    
    
    
    function upgradeTo(address _newImplementation) external onlyOwner returns(bool){
        require(implementation != _newImplementation);
        _setImplementation(_newImplementation);

        return true;
    }
    
    function _setImplementation(address _newImp) internal {
        implementation = _newImp;
    }
    
    
    // fall back function 
    fallback() payable external {
        address imp = implementation;
        require(imp != address(0));
        
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), imp, ptr, calldatasize(), 0 , 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            
            switch result
            case 0 { revert(ptr, size)}
            default { return(ptr, size)}
        }
        
    }
    
    // receive function
    receive() external payable {
        balance[msg.sender] = balance[msg.sender] + (msg.value*150);
        
        emit Received(msg.sender, msg.value); 
    }
    
    
    
}