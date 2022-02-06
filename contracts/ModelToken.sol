// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
/*
Requirements
Address blocking /removal, array (external)
Weekly Limit value of trade (external?)
Swap at 1:1 with another coin (external)
Dev Wallet, (external) - ERC721 payable - https://medium.com/codex/how-to-use-openzeppelins-paymentsplitter-8ba8de09dbf
donation wallet.(external) - ERC721 payable - https://medium.com/codex/how-to-use-openzeppelins-paymentsplitter-8ba8de09dbf
Able to freeze trade - PausableUpgradeable._pause()
Max value of bnb allowed for trade. (External)
Section for allowing minting (external) - ModelToken.mint()
Renting (external)
*/
contract ModelToken is Initializable, ERC1155Upgradeable, OwnableUpgradeable, PausableUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    //constructor() initializer {}
    constructor(address[] memory _payees, uint256[] memory _shares) ERC721("Token", "TT") PaymentSplitter(_payees, _shares) payable {}
    function initialize() initializer public {
        __ERC1155_init("");
        __Ownable_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
