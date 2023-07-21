// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Degen Gaming allows:
// Minting new tokens: Create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// Transferring tokens: Players can transfer their tokens to others.
// Redeeming tokens: Players can redeem their tokens for items in the in-game store.
// Checking token balance: Players can check their token balance at any time.
// Burning tokens: Anyone can burn tokens, that they own, that are no longer needed.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    mapping(uint256 => uint256) public itemPrices;
    mapping(address => mapping(uint256 => bool)) public hasClaimedItem;

    constructor() ERC20("Degen", "DGN") {}

    // for owner to mint tokens
    function mint(address to, uint256 amount) public onlyOwner {
            _mint(to, amount);
    }

    // to check token balance 
    function balance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

     // to transfer tokens
     function transfer(address to, uint256 amount) public override returns (bool) {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");  
        _transfer(msg.sender, to, amount);
        return true;
    }

    // to burn tokens 
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    // in game store
    function store() public pure returns (string memory) {
        return "1. Artifacts for 500 2. Exclusive Skins for 200 3. Moonbirds NFT for 100";
    }

    // to redeem items
    function redeem(uint256 itemId) public {
        itemPrices[1] = 500;
        itemPrices[2] = 200;
        itemPrices[3] = 100;

        require(itemPrices[itemId] > 0, "Invalid item ID");
        require(balanceOf(msg.sender) >= itemPrices[itemId], "Insufficient balance");
        require(!hasClaimedItem[msg.sender][itemId], "Item already claimed");

        _transfer(msg.sender, owner(), itemPrices[itemId]);
        hasClaimedItem[msg.sender][itemId] = true;
    }

}
