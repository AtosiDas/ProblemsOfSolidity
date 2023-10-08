// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShipmentService {
    address private owner;
    constructor() {
        owner = msg.sender;
    }
    function OnlyOwner() private view{
        require(msg.sender == owner);
    }
    struct OrderDetails {
        string Status;
        uint PIN;
        uint DeliveredOrders;
    }
    mapping(address => OrderDetails) order;
    address[] customers;

    //This function inititates the shipment
    function shipWithPin(address customerAddress, uint pin) public {
        OnlyOwner();
        require(owner != customerAddress);
        require(pin > 999 && pin <10000);
        for(uint i = 0; i < customers.length; i++){
            if(customers[i] == customerAddress){
                require(keccak256(abi.encodePacked(order[customerAddress].Status)) == keccak256(abi.encodePacked("no orders placed")) || keccak256(abi.encodePacked(order[customerAddress].Status)) == keccak256(abi.encodePacked("delivered")));
            }
        }
        order[customerAddress].Status = "shipped";
        order[customerAddress].PIN = pin;
        customers.push(customerAddress);
    }

    //This function acknowlegdes the acceptance of the delivery
    function acceptOrder(uint pin) public {
        require(order[msg.sender].PIN == pin);
        order[msg.sender].Status = "delivered";
        order[msg.sender].DeliveredOrders++;
    }

    //This function outputs the status of the delivery
    function checkStatus(address customerAddress) public view returns (string memory){
        require(msg.sender == customerAddress || msg.sender == owner);
        if(order[customerAddress].PIN == 0){
            return "no orders placed";
        }
        return order[customerAddress].Status;
    }

    //This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(address customerAddress) public view returns (uint) {
        require(msg.sender == customerAddress || msg.sender == owner);
        return order[customerAddress].DeliveredOrders;
    }
}
