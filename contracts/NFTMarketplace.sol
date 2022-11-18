// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice = 0.025 ether;
    address payable owner;

    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only owner of the marketplace can change the listing price"
        );
        _;
    }

    constructor() ERC721("Metaverse Tokens", "METT") {
        owner = payable(msg.sender);
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint256 _listingPrice)
        public
        payable
        onlyOwner
    {
        require(
            owner == msg.sender,
            "Only marketplace owner can update listing price."
        );
        listingPrice = _listingPrice;
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /* Mints a token and lists it in the marketplace */
    function createToken(string memory tokenURI, uint256 price)
        public
        payable
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        createMarketItem(newTokenId, price);
        return newTokenId;
    }

    function createMarketItem(uint256 tokenId, uint256 price) private {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );

        idToMarketItem[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false
        );

        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    /* allows someone to resell a token they have purchased */
    function resellToken(uint256 tokenId, uint256 price) public payable {
        require(
            idToMarketItem[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );
        idToMarketItem[tokenId].sold = false;
        idToMarketItem[tokenId].price = price;
        idToMarketItem[tokenId].seller = payable(msg.sender);
        idToMarketItem[tokenId].owner = payable(address(this));
        _itemsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(uint256 tokenId) public payable {
        uint256 price = idToMarketItem[tokenId].price;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        idToMarketItem[tokenId].owner = payable(msg.sender);
        idToMarketItem[tokenId].sold = true;
        idToMarketItem[tokenId].seller = payable(address(0));
        _itemsSold.increment();
        _transfer(address(this), msg.sender, tokenId);
        payable(owner).transfer(listingPrice);
        payable(idToMarketItem[tokenId].seller).transfer(msg.value);
    }

    /* Returns all unsold market items */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint256 itemCount = _tokenIds.current();
        uint256 unsoldItemCount = _tokenIds.current() - _itemsSold.current();
        uint256 currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint256 i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(this)) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns only items that a user has purchased */
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns only items a user has listed */
    function fetchItemsListed() public view returns (MarketItem[] memory) {
        uint256 totalItemCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender) {
                uint256 currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}

// //INTERNAL IMPORT FOR NFT OPENZIPLINE
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// import "hardhat/console.sol";

// contract NFTMarketplace is ERC721URIStorage{
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;
//     Counters.Counter private _itmesSold;

//     uint256 listingPrice = 0.0025 ether;
//     address payable owner;
//     mapping(uint256 => MarketItem) private idMarketItem;
//     struct MarketItem{
//         uint256 tokenId;
//         address payable seller;
//         address payable owner;
//         uint256 price;
//         bool sold;
//     }

//     event idMarketItemCreated(
//         uint256 indexed tokenId,
//         address seller,
//         address owner,
//         uint256 price,
//         bool sold
//     );

//     modifier onlyOwner(){
//         require(
//             msg.sender == owner,
//             "only owner of the marketplace can change the listing price"
//         );
//         _;
//     }
//     constructor() ERC721("NFT Metavarse Token", "MYNFT"){
//         owner == payable(msg.sender);
//     }

//     function updateListingPrice(uint256 _ListingPrice) public payable onlyOwner
//     {
//         listingPrice = listingPrice;
//     }

//     function getListingPrice() public view returns (uint256){
//         return listingPrice;
//     }

//     //Let create " CREATE NFT TOKEN FUNCTION"
//     function createToken(string memory tokenURI, uint256 price)
//         public
//         payable
//         returns (uint256)
//     {
//         _tokenIds.increment();
//         uint256 newTokenId = _tokenIds.current();
//         _mint(msg.sender, newTokenId);
//         _setTokenURI(newTokenId, tokenURI);

//         createMarketItem(newTokenId, price);

//         return newTokenId;
//     }
//     function createMarketItem(uint256 tokenId, uint256 price) private{
//         require(price>0, "Price must be atlest 1");
//         require(msg.value == listingPrice, "Price must be equal to listing price");
//         idToMarketItem[tokenId] = MarketItem(
//             tokenId,
//             payable(msg.sender),
//             payable(address(this)),
//             price,
//             false
//         );

//         _transfer(msg.sender, address(this), tokenId);
//         emit MarketItemCreated(
//             tokenId,
//             msg.sender,
//             address(this),
//             price,
//             false
//         );
//     }
//     //function for resale token
//     function reSellToken(uint256 tokenId, uint256 price) public payable{
//         require(idMarketItem[tokenId].owner == msg.sender, "Only item owner can perform the change");
//         require(msg.value == listingPrice, "Price must be equal to listing price");
//         idMarketItem[tokenId].sold = false;
//         idMarketItem[tokenId].price = price;
//         idMarketItem[tokenId].seller = payable(msg.sender);
//         idMarketItem[tokenId].owner = payable(address(this));

//         _itmesSold.decrement();
//         _transfer(msg.sender, address(this), tokenId);
//     }

//     //function create item sell
//     function createMarketSale(uint256 tokenId) public payable{
//         uint256 price = idMarketItem[tokenId].price;
//         require(
//             msg.value == price,
//             "Please submit the asking price in order to complete the purchase"
//         );
//         idMarketItem[tokenId].owner = payable(msg.sender);
//         idMarketItem[tokenId].sold = true;
//         idMarketItem[tokenId].owner = payable(address(0));

//         _itmesSold.increment();
//         _transfer(address(this), msg.sender, tokenId);
//         payable(owner).transfer(listingPrice);
//         payable(idMarketItem[tokenId].seller).transfer(msg.value);

//     }

//     //getting unsold nft data
//     function fetchMarketitem() public view returns(MarketItem[] memory){
//         uint256 itemCount = _tokenIds.current();
//         uint256 unSoldItemCount = _tokenIds.current() - _itmesSold.current();
//         uint256 currentIndex = 0;

//         MarketItem[] memory items = new MarketItem[](unSoldItemCount);
//         for (uint256 i = 0; i < itemCount; i++) {
//             if (idToMarketItem[i + 1].owner == address(this)) {
//                 uint256 currentId = i + 1;
//                 MarketItem storage currentItem = idToMarketItem[currentId];
//                 items[currentIndex] = currentItem;
//                 currentIndex += 1;
//             }
//         }
//         return items;
//     }

//     //purchase item
//     function fecthMyNFT() public view returns(MarketItem[] memory){
//         uint256 totalItemCount = _tokenIds.current();
//         uint256 itemCount = 0;
//         uint256 currentIndex = 0;

//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (idToMarketItem[i + 1].owner == msg.sender) {
//                 itemCount += 1;
//             }
//         }

//         MarketItem[] memory items = new MarketItem[](itemCount);
//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (idToMarketItem[i + 1].owner == msg.sender) {
//                 uint256 currentId = i + 1;
//                 MarketItem storage currentItem = idToMarketItem[currentId];
//                 items[currentIndex] = currentItem;
//                 currentIndex += 1;
//             }
//         }
//         return items;
//     }

//     //single user items
//     function fetchItemsListed() public view returns (MarketItem[] memory){
//         uint256 totalItemCount = _tokenIds.current();
//         uint256 itemCount = 0;
//         uint256 currentIndex = 0;

//         for (uint256 i = 0; i < totalItemCount; i++) {
//             if (idMarketItem[i+1].seller == msg.sender){
//                 itemCount += 1;
//             }
//         }

//         MarketItem[] memory items = new MarketItem[](itemCount);
//         for (uint256 i = 0;i < totalItemCount; i++){
//             if(idMarketItem[i+1].seller == msg.sender){
//                 uint256 currentid = i+1;
//                 MarketItem storage currentItem = idMarketItem[currentid];
//                 items[currentIndex] = currentItem;
//                 currentIndex += 1;
//             }
//         }
//         return items;
//     }
// }



