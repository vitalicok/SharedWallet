pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import  "./utils/OwnerExtension.sol";

/*
Contract module that serves for storing data
of a key-pair user-amount with a possibility 
to add and remove money to a specific user
*/
contract Allowance is OwnerExtension {
    
    /*
    An event that allows to write down the 
    information of transaction status along
    with a person from who this transaction
    has been performed with a person for who
    this money is sent, _oldAmount represents
    and old amount of money whereas _newAmount
    says how much amount has incresed so the difference
    between them shows what is the amount that was spent
    */
    event AllowanceChanged(address indexed _forWho, address indexed _fromWho, uint _oldAmount, uint _newAmount);
    
    /**
    Variable that collects all the parties that will 
    interact with each other so in the end being added
    to this variable then can carry out transactions 
    with other entitled user among the limited network
    */
    mapping(address => uint) public allowance;
    
    /**
    Method allows to add a certain amount of money
    to a specific user to the hash-map table,
    in this case to "allowance" mapper
    */
    function addAllowance(address _who, uint _amount) public {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
    
    /*
    Modifier that encapsulates requirements logic
    */
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed");
        _;
    }
    
    /**
    Method allows to remove a certain amount of money
    given to a specific user
    */
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who] - _amount);
        allowance[_who] -= _amount;
    }
}

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
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed {
        require(_amount <= address(this).balance, "There are not enough funds stored in the smart contract");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    /*
    Annonymous function that allows you to deposit money 
    to the smart contract
    */
    fallback() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
