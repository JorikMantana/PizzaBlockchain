// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract PizzaSmartContract
{
    address payable public owner;

    constructor()
    {
        owner = payable(msg.sender);
        roles[owner] = Roles.Manager;
    }

    enum Roles
    {
        Admin,
        User,
        Manager
    }

    struct User
    {
        string Name;
        string Password;
    }

    modifier OnlyManager()
    {
        require(roles[msg.sender] == Roles.Manager);
        _;
    }

    modifier OnlyUser()
    {
        require(roles[msg.sender] == Roles.User);
        _;
    }

    struct Drink
    {
        string Name;
        string Description;
        string[] Ingredients;
        int Price;
        int Rating;
    }

    struct Pizza
    {
        string Name;
        string Description;
        string[] Ingredients;
        uint256 Price;
        int Rating;           
    }
    Pizza[] public pizzas;

    struct Receipt
    {
        address buyer;
        string buyedPizzaName;
    }

    Receipt[] public receipts;


    mapping (address => Roles) public roles;
    mapping (address => User) public users;

    function AddPizzaToProducts(string memory name, string memory description, string[] memory ingredients, uint256 price, int rating) public OnlyManager
    {
        Pizza memory newPizza = Pizza(
        {
            Name: name,
            Description: description,
            Ingredients: ingredients,
            Price: price,
            Rating: rating
        });

        pizzas.push(newPizza);
    }

    function BuyPizzas(uint256 pizzaId) public payable  OnlyUser
    {
        require(msg.value == pizzas[pizzaId].Price, "No money");

        Receipt memory newReceipt = Receipt(
        {
            buyer: msg.sender,
            buyedPizzaName: pizzas[pizzaId].Name
        });

        // Pizza[] memory purchasedPizzas = new Pizza[](pizzaIndices.length);
        // uint256 price;

        // for(uint256 i = 0; i < pizzaIndices.length; i++)
        // {
        //     Pizza storage pizza = pizzas[pizzaIndices[i]];
        //     price += pizza.Price;
        //     purchasedPizzas[i] = pizza;
        // }

        // require(msg.value >= price, "Insufficient funds");

        // Receipt memory newReceipt = Receipt(
        //     {
        //         buyer: msg.sender,
        //         buyedPizzasIndexes: pizzaIndices
        //     }
        // );

        // receipts.push(newReceipt);
    }

    function GetPizzas() public view returns (Pizza[] memory)
    {
        return pizzas;
    }

    function Registration(string memory name, string memory password) public
    {
        require(roles[msg.sender] != Roles.User, "You're user alreeady");
        roles[msg.sender] = Roles.User;
        users[msg.sender] = User(name, password);
    }
}