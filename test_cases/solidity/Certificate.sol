// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Certificate {
    address public issuer;
    uint256 public certificateCount;
    mapping(uint256 => address) public certificateOwner;
    mapping(uint256 => bool) public certificateValid;
    mapping(address => uint256) public ownerCertificateCount;

    event CertificateIssued(uint256 indexed certId, address indexed recipient);
    event CertificateRevoked(uint256 indexed certId);
    event CertificateTransferred(uint256 indexed certId, address indexed from, address indexed to);

    modifier onlyIssuer() {
        require(msg.sender == issuer, "Not issuer");
        _;
    }

    constructor() {
        issuer = msg.sender;
        certificateCount = 0;
    }

    function issueCertificate(address recipient) public onlyIssuer {
        require(recipient != address(0), "Invalid recipient");
        certificateCount = certificateCount + 1;
        certificateOwner[certificateCount] = recipient;
        certificateValid[certificateCount] = true;
        ownerCertificateCount[recipient] = ownerCertificateCount[recipient] + 1;
        emit CertificateIssued(certificateCount, recipient);
    }

    function revokeCertificate(uint256 certId) public onlyIssuer {
        require(certificateValid[certId], "Not valid");
        certificateValid[certId] = false;
        emit CertificateRevoked(certId);
    }

    function transferCertificate(uint256 certId, address to) public {
        require(certificateOwner[certId] == msg.sender, "Not owner");
        require(certificateValid[certId], "Not valid");
        ownerCertificateCount[msg.sender] = ownerCertificateCount[msg.sender] - 1;
        ownerCertificateCount[to] = ownerCertificateCount[to] + 1;
        certificateOwner[certId] = to;
        emit CertificateTransferred(certId, msg.sender, to);
    }

    function isValid(uint256 certId) public view returns (bool) {
        return certificateValid[certId];
    }
}
