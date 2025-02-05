## Basic Signature-Airdrop-Project

## Description:
This is an merkle signature airdrop tokens project. 
Airdrop tokens are free cryptocurrency tokens or coins that are distributed to multiple wallet addresses.

## Technologies Used
-Solidity: Smart contract programming language.
=Foundry: A powerful development environment for Ethereum.
-Forge: Used for writing and running tests.
-Merkle tree: Type of tree that every "leaf" node is labelled with the cryptographic hash of a data block
-Merkle proof: Data structure that uses hashing to verify the authenticity of data.

## Features used:
- ERC20 tokens,
- Merkle trees,
-  EIP712
-   and ECDSA

## The src(source) Folder
-Has an simple AirdropToken contract that:
-Imports ERC20 and Ownable contracts from Openzeppelin
- Passes both of these contracts in the constructor since it has an constructor inside of these of these contracts also
- Gives an name of the token and passes ownable in the constructor as the msg.sender(sender of the message )
-Has an function mint which has onlyOwner modifier so that only the owner of the contract can mint an amount of tokens.

-Has an MerkleAirdrop contract that has:
-Merkle Airdrop System – Distributes ERC-20 tokens securely using a Merkle tree.
-Claim Verification – Users must provide a valid Merkle proof and digital signature to claim.
-One-Time Claim – Each address can only claim tokens once.
-Fraud Prevention – Invalid proofs or signatures cause the transaction to revert.
-Secure Transfers – Uses safeTransfer to send tokens safely.
-Transparency – Provides functions to check the Merkle root and airdrop token details.

## Tests
It has an MerkleAirdropTest that has:
-Test Setup – Deploys MerkleAirdrop and AirdropToken, assigns tokens, and creates a test user.
-Merkle Proof Verification – Uses predefined Merkle proofs to simulate a claim scenario.
-User Claim Simulation – Generates a digital signature for the user and attempts a token claim.
-Gas Payer Mechanism – Allows a third party (gas payer) to submit the claim on behalf of the user.
-Balance Validation – Ensures the user's token balance increases correctly after a successful claim.
-Security Check – Confirms that only valid claims with correct proofs and signatures succeed.

## Deployment 
Deployment Scripts

1. ClaimAirdrop.s.sol
-This script is used to claim tokens from a Merkle Airdrop.
-It verifies the claim using a Merkle proof and a cryptographic signature.
-The script retrieves the latest deployed MerkleAirdrop contract and executes the claim.
-Uses Foundry’s vm.startBroadcast() to interact with the blockchain.
-If successful, it prints "Successful claimed" to the console.

2. DeployMerkleAirdrop.s.sol
-Deploys the MerkleAirdrop smart contract to the blockchain.
-Stores a Merkle root, which allows users to claim tokens if they have a valid proof.
-Uses Foundry's vm.broadcast() to deploy the contract.
-After deployment, it logs the contract address for reference.
-This contract is essential for managing token distributions via Merkle proofs.

4. MakeMerkle.s.sol
-Generates a Merkle proof for token distribution.
-Reads input addresses and amounts from a JSON file.
-Computes the Merkle tree and stores the root, proofs, and leaves.
-Outputs the generated Merkle tree data to a JSON file.
-This proof is required for users to claim their airdropped tokens.

5. GenerateInput.s.sol
-Creates an input JSON file with addresses and token amounts.
-This file serves as the source for Merkle proof generation.
-Helps structure the data before running MakeMerkle.s.sol.
-Ensures the correct format for later verification in the airdrop contract.
-Without this step, the Merkle proof generation cannot proceed.

It also has an input and output json files that contains the data the generateinput gives!


## Libraries used:
Forge-std from Foundry
Foundry-devops from Cyfrin
Murky- from dmfxyz
Openzeppelin-contracts from Openzeppelin

## Inspiration:
This contract is inspired in Cyfrin Signature and Airdrops Lessons.

## License:
MIT



