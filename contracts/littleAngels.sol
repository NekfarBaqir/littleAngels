// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";


import './lib/Ownable.sol';


contract LittleAngels is ERC721, Pausable ,Ownable{

    using Address for address payable;
    using Counters for Counters.Counter;
    using Address for address;
    using Strings for uint256;
    using ECDSA for bytes32;

    string private constant MINT_NOT_STARTED = "Mint Not started";  
    string private constant NON_EXISTENT_TOKENURI = "NFT not existed"; 
    string private constant BAD_ADDRESS_ERROR = "The Sender is a contract";
    string private constant SUPPLY_LIMIT_ERROR = "MaxSuppy reached";
    string private constant INCORRECT_FUNDS = "Incorrect value sent!";
    string private constant MAX_PER_wALLET_REACHED = "Exceeded per wallet!";
    string private constant MAX_MINT_AMOUNT_PER_TX = "Exceeded max per tx";
    string private constant NOT_WHITELISTED = "Not Whitelisted!";
    string private constant WHITELIST_USED = "Whitelist used!";
    string private constant PUBLIC_SALE_NOT_ACTIVE = "public sale is not active";
    string private constant WHITELIST_SALE_NOT_ACTIVE = "whitelist sale is not active";

    uint256 constant MAX_SUPPLY = 5555;
    uint256 constant MAX_PER_WALLET = 20;
    uint256 constant PURCHASE_LIMIT = 5;
    uint256 constant WHITELIST_PURCHASE_LIMIT = 2;
    uint256 public price = 0.085 ether;
    uint256 public whitelistPrice = 0.075 ether;
    address private signerAddress;
    string private tokenBaseURI = "ipfs://QmdM6nPavCssSgY3Ghwomkf5sWDVuf93b4hvjvw8SDyxoZ";
    bool public publicSaleActive = false;

    mapping(address => uint256) public addressMintedBalance;
    mapping(address => bool) public whitelistClaimed;
    Counters.Counter private ids;



    // events
    event Revealed(address indexed operator, string baseUri);
    event NFTMinted(address indexed operator, uint256 _amount);

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) {
          signerAddress = _msgSender();
    }
    
    // modifiers 
    modifier noContract(){
        require(!_msgSender().isContract(), BAD_ADDRESS_ERROR);
        _;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        uint256  ownerMintedCount = addressMintedBalance[_msgSender()];
        require(publicSaleActive ==true,PUBLIC_SALE_NOT_ACTIVE);
        require((_mintAmount + ownerMintedCount) <= MAX_PER_WALLET, MAX_PER_wALLET_REACHED);
        require(_mintAmount > 0 && _mintAmount <= PURCHASE_LIMIT, MAX_MINT_AMOUNT_PER_TX);
        require(ids.current() + _mintAmount <= MAX_SUPPLY, SUPPLY_LIMIT_ERROR);
        require(msg.value ==_mintAmount * price, INCORRECT_FUNDS);
        _;
    }

    modifier whiteListMintCompliance(uint256 _mintAmount,uint256 limit, bytes memory signature) {
        require(publicSaleActive ==false, WHITELIST_SALE_NOT_ACTIVE);
        require(_validSignature(signature,limit), NOT_WHITELISTED);
        require(ids.current() + _mintAmount <= MAX_SUPPLY, SUPPLY_LIMIT_ERROR);
        require(_mintAmount > 0 && _mintAmount <= limit, MAX_MINT_AMOUNT_PER_TX);
        require(msg.value ==_mintAmount * whitelistPrice, INCORRECT_FUNDS);
        require(!whitelistClaimed[_msgSender()], WHITELIST_USED);
        _;
    }


    // getting information functions
    function totalTokenSupply() public pure returns (uint256) {
        return MAX_SUPPLY;
    }

    function currentTokenCount() public view returns (uint) {
        return uint(ids.current());
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return tokenBaseURI;
    }



    // setter functions
   function reveal(string memory baseURI_) external onlyOwner{
       tokenBaseURI = baseURI_;
       emit Revealed(_msgSender(), tokenBaseURI);
   }
    function pause() public onlyOwner {
        _pause();
    }
    function unpause() public onlyOwner {
        _unpause();
    }
    function setPublicSaleActive(bool _status) public onlyOwner {
        publicSaleActive = _status;
    }
    function setPublicPrice(uint256 _price) public onlyOwner {
        price = _price;
    }
    function setWhiteListPrice(uint256 _price) public onlyOwner {
        whitelistPrice = _price;
    }
    function setSignerAddress(address _signer) public onlyOwner{
        signerAddress = _signer;
    }



    // internal functions
    function _validSignature(bytes memory signature, uint256 limit) internal view returns (bool) {
        bytes32 msgHash = keccak256(abi.encode(address(this), _msgSender(),limit));
        return msgHash.toEthSignedMessageHash().recover(signature) == signerAddress;
    }

    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        for(uint i = 0; i<_mintAmount;i++){
            ids.increment();
            uint newTokenId = uint(ids.current());
            _mint(_receiver, newTokenId);
        }
    }

    function mint(uint256 _times) external payable  noContract mintCompliance(_times){
        _mintLoop(_msgSender(), _times);
        addressMintedBalance[_msgSender()] += _times;
        emit NFTMinted(_msgSender(),_times);
    }

    function whiteListMint(uint256 _times,uint256 limit, bytes memory signature) public payable noContract whiteListMintCompliance(_times,limit, signature){
       _mintLoop(_msgSender(), _times);
       whitelistClaimed[_msgSender()] = true;
       addressMintedBalance[_msgSender()] += _times;
       emit NFTMinted(_msgSender(),_times);
    }

    function giveAway(uint256 _times, address _to) external onlyOwner   {
        require(!_to.isContract(), BAD_ADDRESS_ERROR);
        require(currentTokenCount()+_times < MAX_SUPPLY, SUPPLY_LIMIT_ERROR);
        _mintLoop(_to,_times);
    }

    function withdrawEthers(uint amount, address payable _to) external onlyOwner {
        require(!_to.isContract(), BAD_ADDRESS_ERROR);
        _to.sendValue(amount*10**18);
    }

}