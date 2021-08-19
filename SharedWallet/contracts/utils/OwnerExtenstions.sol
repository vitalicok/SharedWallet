pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
/*
Extension module is going to be serving as an 
extended logic and helper for owner interaction 
along with extending an existing module which is 
Ownable that does not have enough functionalities
for actions that will be made for the main project
*/
abstract contract OwnerExtenstions is Ownable{
    
    
    /*
    Verifies whether caller is the current owner
    */
    
    function isOwner() public view returns (bool) {
        return _msgSender() == owner();
    }
    
}