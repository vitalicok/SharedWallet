pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import  "./utils/OwnerExtenstions.sol";

/*
Contract module that serves for storing data
of a key-pair user-amount with a possibility 
to add and remove money to a specific user
*/
contract Allowance is OwnerExtenstions {
    
    using SafeMath for uint;
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
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
}