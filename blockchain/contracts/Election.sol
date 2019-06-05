pragma solidity >=0.4.21 <0.6.0;

contract Election {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Read/write candidates
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    constructor () public {
        addCandidate("Cand1");
        addCandidate("Cand2");
    }

    function addCandidate (string memory _name) public {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote (uint candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(candidateId > 0 && candidateId <= candidatesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[candidateId].voteCount ++;

        // Event emmitten
        emit reqCandidate(msg.sender);
    }

    event reqCandidate (
        // Dieses Event wird emitted und vom Backend beobachet
        address indexed _candidateId
    );
}