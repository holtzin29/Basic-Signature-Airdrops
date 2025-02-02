// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract MerkleAirdrop is EIP712 {
    using SafeERC20 for IERC20;

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();

    // list of address
    // allow someone to claim tokens
    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    mapping(address claimer => bool claimed) private s_hasClaimed; // mapping from claimer to claimed to keep track of the people that has claimed already
    bytes32 private constant MESSAGE_TYPEHASH =
        keccak256("AirdropClaim(address account, uint256 amount)");

    struct AirdropClaim {
        address account;
        uint256 amount;
    }

    event Claim(address account, uint256 amount);

    constructor(
        bytes32 merkleRoot,
        IERC20 airdropToken
    ) EIP712("MerkleAirdrop", "01") {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    // merkle proofs
    // since its an array you gotta especify where its gonna be stored
    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        if (s_hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed(); // if they already claimed they can't claim again, you need to do that first before updating the mapping though
        }
        if (
            // sig not valid)
            !_isValidSignature(
                account,
                getMessageHash(account, amount),
                v,
                r,
                s
            )
        ) {
            revert MerkleAirdrop__InvalidSignature();
        }

        // calculate using the account and the amount, the hash = leaf nodes
        bytes32 leaf = keccak256(
            bytes.concat(keccak256(abi.encode(account, amount)))
        ); // encode them toghether mashed them and hashed them twice to avoid collisions
        if (
            !MerkleProof.verify(merkleProof, i_merkleRoot, leaf)
        ) //uses the leaf to calculate an expected root and compare to actual root
        {
            revert MerkleAirdrop__InvalidProof();
        }
        s_hasClaimed[account] = true; // see if the account has already claimed
        emit Claim(account, amount);
        i_airdropToken.safeTransfer(account, amount); // if the expected root was the actual root an account and amount will be transfered
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }

    function getMessageHash(
        address account,
        uint256 amount
    ) public view returns (bytes32 digest) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        MESSAGE_TYPEHASH,
                        AirdropClaim({account: account, amount: amount})
                    )
                )
            );
    }

    function _isValidSignature(
        address account,
        bytes32 digest,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (bool) {
        (address actualSigner, , ) = ECDSA.tryRecover(digest, v, r, s);
        return actualSigner == account;
    }
}
