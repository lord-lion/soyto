pragma solidity >=0.7.0 <0.9.0;

contract SoyTo {

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    string public constant name = "Soya Token";
    string public constant symbol = "SOYTO";
    uint8 public constant decimals = 18;

    mapping(address => uint256) private balances;

    mapping(address => mapping (address => uint256)) private allowed;

    uint256 private totalSupply_;

    // Structure pour stocker les détails des transactions
    struct Transaction {
        address from;
        address to;
        uint tokens;
    }

    // Historique des transactions
    Transaction[] private transactionHistory;

    constructor(uint256 total) {
      totalSupply_ = total;
      balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view returns (uint256) {
      return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;

        // Enregistrer la transaction dans l'historique
        transactionHistory.push(Transaction(msg.sender, receiver, numTokens));

        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;

        // Enregistrer la transaction dans l'historique
        transactionHistory.push(Transaction(owner, buyer, numTokens));

        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    // Obtenir le nombre total de transactions
    function getTransactionHistoryCount() public view returns (uint) {
        return transactionHistory.length;
    }

    // Obtenir les détails d'une transaction spécifique
    function getTransaction(uint index) public view returns (address, address, uint) {
        require(index < transactionHistory.length);
        Transaction memory transaction = transactionHistory[index];
        return (transaction.from, transaction.to, transaction.tokens);
    }
}
