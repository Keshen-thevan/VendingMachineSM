//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VendingMachine{
    string[] ListOfItems;   //the array contains all the names of the items
    address payable owner;

    constructor (){
        owner = payable(msg.sender);
    }

    //the struct contains all the information of an item
    struct S_Item {
        string name;
        uint price;
        uint stock;
    }
    mapping (uint => S_Item) public options;    //maps a uint to a item
    uint index = 1;

    modifier onlyOwner(){
        require(msg.sender == owner, "Can only be used by owner.");
        _;
    }

    //allows the owner to add items to the vending machine
    function addItem(string memory _name, uint _price, uint _stock ) public onlyOwner{
        options[index].name = _name;
        options[index].price = _price * 1 ether;
        options[index].stock = _stock;
        ListOfItems.push(_name);
        index++;
    }

    //shows the list of all the items available
    function showList() public view returns (string[] memory){
        return(ListOfItems);
    }

    //allows the customer to make a purchase
    function purchase(uint _choice, uint _amount) public payable{
        require(msg.value >= _amount * options[_choice].price, "You need to pay more.");
        require(options[_choice].stock >= _amount, "We are out of stock on this item .");
        options[_choice].stock -= _amount;
    }

    function editItemPrice(uint _index, uint _price)public onlyOwner{
        options[_index].price = _price;
    }
    
    function editItemStock(uint _index, uint _stock)public onlyOwner{
        options[_index].stock = _stock;
    }

    //returns the balance of the contract
    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    //allows the owner to witdraw the money from the contract
    function withdraw() payable public onlyOwner{
        payable(msg.sender).transfer(payable(address(this)).balance);
    }

}