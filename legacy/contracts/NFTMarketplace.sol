// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMarketplace {
    struct NFT {
        uint256 tokenId;
        address owner;
        uint256 price;
        bool forSale;
    }
    
    struct Offer {
        address buyer;
        uint256 tokenId;
        uint256 offerAmount;
        bool active;
    }
    
    mapping(uint256 => NFT) public nfts;
    mapping(uint256 => Offer[]) public offersForNFT;
    uint256 public nextTokenId;
    
    event NFTCreated(uint256 indexed tokenId, address indexed owner);
    event NFTListed(uint256 indexed tokenId, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed from, address indexed to, uint256 price);
    event OfferMade(uint256 indexed tokenId, address indexed buyer, uint256 offerAmount);
    event OfferAccepted(uint256 indexed tokenId, address indexed buyer, uint256 offerAmount);
    
    error NotOwner(uint256 tokenId, address caller, address owner);
    error NotForSale(uint256 tokenId);
    error InsufficientFunds(uint256 required, uint256 provided);
    error InvalidTokenId(uint256 tokenId);
    
    modifier onlyOwner(uint256 tokenId) {
        if (nfts[tokenId].owner != msg.sender) {
            revert NotOwner(tokenId, msg.sender, nfts[tokenId].owner);
        }
        _;
    }
    
    function createNFT() public returns (uint256) {
        uint256 tokenId = nextTokenId++;
        nfts[tokenId] = NFT(tokenId, msg.sender, 0, false);
        
        emit NFTCreated(tokenId, msg.sender);
        return tokenId;
    }
    
    function listNFTForSale(uint256 tokenId, uint256 price) public onlyOwner(tokenId) {
        nfts[tokenId].price = price;
        nfts[tokenId].forSale = true;
        
        emit NFTListed(tokenId, price);
    }
    
    function buyNFT(uint256 tokenId) public payable {
        NFT storage nft = nfts[tokenId];
        
        if (!nft.forSale) {
            revert NotForSale(tokenId);
        }
        
        if (msg.value < nft.price) {
            revert InsufficientFunds(nft.price, msg.value);
        }
        
        address previousOwner = nft.owner;
        nft.owner = msg.sender;
        nft.forSale = false;
        
        // Transfer funds to previous owner
        payable(previousOwner).transfer(msg.value);
        
        emit NFTSold(tokenId, previousOwner, msg.sender, msg.value);
    }
    
    function makeOffer(uint256 tokenId) public payable {
        if (tokenId >= nextTokenId) {
            revert InvalidTokenId(tokenId);
        }
        
        offersForNFT[tokenId].push(Offer(msg.sender, tokenId, msg.value, true));
        
        emit OfferMade(tokenId, msg.sender, msg.value);
    }
    
    function acceptOffer(uint256 tokenId, uint256 offerIndex) public onlyOwner(tokenId) {
        Offer[] storage offers = offersForNFT[tokenId];
        
        require(offerIndex < offers.length, "Invalid offer index");
        require(offers[offerIndex].active, "Offer is not active");
        
        Offer storage offer = offers[offerIndex];
        offer.active = false;
        
        // Transfer NFT to buyer
        nfts[tokenId].owner = offer.buyer;
        nfts[tokenId].forSale = false;
        
        // Transfer payment to seller
        payable(msg.sender).transfer(offer.offerAmount);
        
        emit OfferAccepted(tokenId, offer.buyer, offer.offerAmount);
        emit NFTSold(tokenId, msg.sender, offer.buyer, offer.offerAmount);
    }
    
    function getOffersCount(uint256 tokenId) public view returns (uint256) {
        return offersForNFT[tokenId].length;
    }
} 