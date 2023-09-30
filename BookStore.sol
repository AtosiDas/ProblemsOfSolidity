// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Bookstore {
    uint TotalNoOfBooks;
    address Owner;
    constructor() {
        Owner = msg.sender;
    }
    struct Book {
        string name;
        string author;
        string publications;
        uint ID;
        bool available;
    }
    //Book[] books;
    uint[] IdDetails;
    //uint[] ArrID;
    mapping(uint => Book) Details;
    modifier onlyOwner {
        require(msg.sender == Owner);
        _;
    }
    // this function can add a book and only accessible by gavin
    function addBook(string memory title, string memory author, string memory publication) public onlyOwner {
        TotalNoOfBooks++;
        Book storage NewBook = Details[TotalNoOfBooks];
        NewBook.name = title;
        NewBook.author = author;
        NewBook.publications = publication;
        NewBook.ID = TotalNoOfBooks;
        NewBook.available = true;
        IdDetails.push(TotalNoOfBooks);
    }

    // this function makes book unavailable and only accessible by gavin
    function removeBook(uint id) public onlyOwner{
        require(id > 0 && id <= TotalNoOfBooks);
        Book storage NewBook = Details[id];
        NewBook.available = false;
        // for(uint i = 0; i < IdDetails.length; i++){
        //     if(IdDetails[i] == id)
        //         IdDetails.pop();
        // }
    }

    // this function modifies the book details and only accessible by gavin
    function updateDetails(
        uint id, 
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available) public onlyOwner {
            bool flag;
            for(uint i = 0; i < IdDetails.length; i++){
                if(IdDetails[i] == id)
                    flag = true;
            }
            require(flag == true,"Id is not available");
            Book storage NewBook = Details[id];
            NewBook.name = title;
            NewBook.author = author;
            NewBook.publications = publication;
            NewBook.available = available;
        }

    // this function returns the ID of all books with given titles
    function findBookByTitle(string memory title) public view returns (uint[] memory) {
        uint[] memory matchingBookIds = new uint[](TotalNoOfBooks);
        uint matchingCount = 0;
        
        for (uint i = 1; i <= TotalNoOfBooks; i++) {
            if (keccak256(abi.encodePacked(Details[i].name)) == keccak256(abi.encodePacked(title))) {
                if (msg.sender == Owner || Details[i].available) {
                    matchingCount++;
                    matchingBookIds[matchingCount - 1] = Details[i].ID;
                }
            }
        }
        
        uint[] memory result = new uint[](matchingCount);
        for (uint j = 0; j < matchingCount; j++) {
            result[j] = matchingBookIds[j];
        }
        
        return result;
    }


    // this function returns the ID of all books with given publication
    function findAllBooksOfPublication (string memory publication) public view returns (uint[] memory )  {
        uint[] memory matchingBookPubs = new uint[](TotalNoOfBooks);
        uint matchingCount = 0;
        
        for (uint i = 1; i <= TotalNoOfBooks; i++) {
            if (keccak256(abi.encodePacked(Details[i].publications)) == keccak256(abi.encodePacked(publication))) {
                if (msg.sender == Owner || Details[i].available) {
                    matchingCount++;
                    matchingBookPubs[matchingCount - 1] = Details[i].ID;
                }
            }
        }
        
        uint[] memory result = new uint[](matchingCount);
        for (uint j = 0; j < matchingCount; j++) {
            result[j] = matchingBookPubs[j];
        }
        
        return result;
    }

    // this function returns the ID of all books with given author
    function findAllBooksOfAuthor (string memory author) public view returns (uint[] memory)  {
        uint[] memory matchingBookAuthors = new uint[](TotalNoOfBooks);
        uint matchingCount = 0;
        
        for (uint i = 1; i <= TotalNoOfBooks; i++) {
            if (keccak256(abi.encodePacked(Details[i].author)) == keccak256(abi.encodePacked(author))) {
                if (msg.sender == Owner || Details[i].available) {
                    matchingCount++;
                    matchingBookAuthors[matchingCount - 1] = Details[i].ID;
                }
            }
        }
        
        uint[] memory result = new uint[](matchingCount);
        for (uint j = 0; j < matchingCount; j++) {
            result[j] = matchingBookAuthors[j];
        }
        
        return result;
    }

    // // this function returns all the details of book with given ID
    function getDetailsById(uint id) public view returns (
        string memory title, 
        string memory author, 
        string memory publication, 
        bool available)  {
            bool flag;
            for(uint i = 0; i<IdDetails.length;i++){
                if(IdDetails[i]== id)
                    flag = true;
            }
            require(flag == true,"Id is not available");
            Book memory NewBook = Details[id];
            if(msg.sender == Owner){
                return (NewBook.name,NewBook.author,NewBook.publications,NewBook.available);
            }
            require(NewBook.available == true,"Book is not available");
            return (NewBook.name,NewBook.author,NewBook.publications,NewBook.available);
        }

}
