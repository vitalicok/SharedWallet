pragma solidity ^0.8.4;

import "./Allowance.sol";
/*
Main contract module which is responsible for everything
that is related to Wallet functionalities and inherits
contract Allowance
*/
contract SharedWallet is Allowance{
    
    /*
    Events record the data of the amount of money 
    that has been either withdrawn or deposited 
    to a certain account respectively
    */
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    /*
    Method that serves for withdrawing money and checking out 
    if an owner who is calling this method is an initial caller
    who started the transaction
    */
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    function renounceOwnership() public override onlyOwner{
        revert("Can't renounce ownership here");
    }
    
    /*
    Annonymous function that allows you to deposit money 
    to the smart contract
    */
    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
