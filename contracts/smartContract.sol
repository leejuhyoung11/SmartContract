// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./HEX0924.sol";

contract safeMath {
    // prevent overflow, underflow
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
        
        return c;
    }
    
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
        
        return c;
    }
}


contract HEX0924_logic is safeMath, HEX0924{
    //address public owner; // owner of proxy contract
    //address public implementation;
    
    
   // mapping (address => uint) public balance;
    mapping (address => uint) public approved;
    mapping(address => mapping (address => uint256)) private allowed;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    
    
    
    function transfer(address to, uint256 value) external returns (bool) {
        require(to > address(0));
        require(balance[msg.sender] >= value);
        require(balance[to] + value >= balance[to]); // check overflow
        
        balance[msg.sender] = safeSub(balance[msg.sender], value);
        balance[to] = safeAdd(balance[to], value);
        
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(from > address(0));
        require(to > address(0));
        require(balance[from] >= value);
        require(balance[to] + value >= balance[to]);
        require(allowed[from][msg.sender] >= value);
        
        balance[from] = safeSub(balance[from], value);
        balance[to] = safeAdd(balance[to], value);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value); 
        
        emit Transfer(from, msg.sender, value);
        return true;
    }
    
    function approve(address spender, uint256 value) external returns (bool) {
        require(spender > address(0));
        
        allowed[msg.sender][spender] = safeAdd(allowed[msg.sender][spender], value);
        
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function totalSupply() external view returns (uint256) {
        return total_amount;
    }
    
    function balanceOf(address who) external view returns (uint256) {
        return balance[who];
    }
    
    function allowance(address owner, address spender) external view returns (uint256) {
        return allowed[owner][spender];
    }
    
    
    
}



















interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
