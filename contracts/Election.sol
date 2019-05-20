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
        emit reqCandidate();
    }

    event reqCandidate();
    event updatedCand(string candAdded);

    function addCandidate (string memory _name) public {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);

        emit updatedCand(_name);
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

        emit votedEvent(candidateId);
    }

    event votedEvent (
        uint indexed _candidateId
    );
}