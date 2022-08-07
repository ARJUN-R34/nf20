// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Fractionalizer is ERC1155, ERC1155Burnable, Ownable, ERC721Holder {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public constant decimals = 18;
    uint256 public constant totalSupply = 100000 * (10 ** decimals);

    struct NFTMetadata {
        address nftCollection;
        uint256 nftTokenId;
        bool isRedeemed;
        string erc20Name;
        string erc20Symbol;
    }

    mapping (uint256 => NFTMetadata) public erc20ToNFT;

    event Fractionalised(uint256 indexed tokenId, address indexed nftCollection, uint256 indexed nftTokenId, address minter);
    event Redeemed(uint256 indexed tokenId, address indexed nftCollection, uint256 indexed nftTokenId, address redeemer);

    constructor() ERC1155("Fractionalizer")

    function fractionalize(address collection, uint256 nftTokenId, string memory name, string memory symbol) external {
        IERC721 ERC721 = IERC721(collection);

        ERC721.transferFrom(msg.sender, address(this), nftTokenId);

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        erc20ToNFT[tokenId] = NFTMetadata({
            nftCollection: collection,
            nftTokenId: nftTokenId,
            isRedeemed: false, erc20Name: name,
            erc20Symbol: symbol
        });

        _mint(msg.sender, tokenId, totalSupply, '0x00');

        emit Fractionalised(tokenId, collection, nftTokenId, msg.sender);
    }

    function userBalances(address user) external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](_tokenIdCounter.current());

        for (uint256 i = 0; i < _tokenIdCounter.current(); i++) {
            balances[i] = balanceOf(user, i);
        }

        return balances;
    }

    function redeem(uint256 tokenId) external {
        require(balanceOf(msg.sender, tokenId) == totalSupply, "Need all supplied ERC20 tokens to redeem NFT");

        NFTMetadata memory nftData = erc20ToNFT[tokenId];

        erc20ToNFT[tokenId].isRedeemed = true;

        _burn(msg.sender, tokenId, totalSupply);

        IERC721 ERC721 = IERC721(nftData.nftCollection);

        ERC721.transferFrom(address(this), msg.sender, nftData.nftTokenId);

        emit Redeemed(tokenId, nftData.nftCollection, nftData.nftTokenId, msg.sender);
    }
}
