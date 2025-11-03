// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Voting {
    // --- State Variables ---
    uint256 public totalVoteCount;
    bool public votingOpen = true;

    address public immutable ADMIN;

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] private candidates;
    mapping(address => bool) private hasVoted;

    // --- Events ---
    event CandidateAdded(string name);
    event VoteCasted(address indexed voter, uint256 indexed candidateIndex);
    event VotingToggled(bool newState);

    // --- Constructor ---
    constructor() {
        ADMIN = msg.sender;
    }

    // --- Modifiers ---
    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == ADMIN, "Only Admin");
    }

    modifier votingActive() {
        _votingActive();
        _;
    }

    function _votingActive() internal view {
        require(votingOpen, "Voting closed");
    }

    // --- Core Functions ---
    function addCandidate(string calldata _name) external onlyAdmin {
        require(bytes(_name).length > 0, "Name required");
        candidates.push(Candidate({name: _name, voteCount: 0}));
        emit CandidateAdded(_name);
    }

    function getCandidates() external view returns (string[] memory) {
        string[] memory names = new string[](candidates.length);
        for (uint256 i = 0; i < candidates.length; i++) {
            names[i] = candidates[i].name;
        }
        return names;
    }

    function vote(uint256 candidateIndex) external votingActive {
        require(candidateIndex < candidates.length, "Invalid candidate index");
        require(!hasVoted[msg.sender], "Already voted");

        hasVoted[msg.sender] = true;
        candidates[candidateIndex].voteCount++;
        totalVoteCount++;

        emit VoteCasted(msg.sender, candidateIndex);
    }

    function toggleVoting() external onlyAdmin {
        votingOpen = !votingOpen;
        emit VotingToggled(votingOpen);
    }

    function getTotalVotes() external view onlyAdmin returns (uint256) {
        require(!votingOpen, "Count after voting closed");
        return totalVoteCount;
    }

    function votesOf(uint256 candidateIndex) external view onlyAdmin returns (uint256) {
        require(candidateIndex < candidates.length, "Invalid index");
        require(!votingOpen, "Count after voting closed");
        return candidates[candidateIndex].voteCount;
    }

    function getWinner() external view onlyAdmin returns (string memory winnerName) {
        require(!votingOpen, "Count after voting closed");
        uint256 maxVotes;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerName = candidates[i].name;
            }
        }
    }
}
