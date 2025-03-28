// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Election is Ownable {

    using SafeMath for uint256;

    // Adresse fixe autorisée à ajouter des candidats (mon adresse)
    address private constant admin = 0xCf174b22f131F0685F369A4dFeB7CF2E0569466a;

    // Model a Candidate
    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    event votedEvent (uint indexed _candidateId);

    // Seule l’adresse admin peut ajouter un candidat
    function addCandidate(string memory _name) public {
        require(msg.sender == admin, "Seul l'administrateur peut ajouter un candidat.");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "Vous avez deja vote.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Candidat invalide.");
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit votedEvent(_candidateId);
    }
}
