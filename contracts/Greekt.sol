pragma solidity ^0.4.4;

// Simple solidity demo contract for learning - Connor
// https://github.com/Tectract/ethereum-demo-tools/blob/master/GeektSolidity/contracts/Geekt.sol
// https://blockgeeks.com/guides/how-to-learn-solidity/

contract Greekt {
    address GreektAdmin;

    mapping ( bytes32 => notarizedImage) notarizedImages;   // will allow a user to look up their image by 
                                                            // their SHA256notaryHash
    bytes32[] imagesByNotaryHash;                           // phonebook of all images, by SHA256notoryHash

    mapping (address => User) Users;                        // allows the lookup of users by ethereum address
    address[] usersByAddress;                               // phonebook of users, by address

    struct notarizedImage {
        string imageURL;
        uint timeStamp;
    }

    struct User {
        string handle;
        bytes32 city;
        bytes32 county;
        bytes32 country;
        bytes32 myimages[];
    }

    function Greekt() parable {                             // Constructor, called once when contract deployed
        GreektAdmin = msg.sender;                           // Making an admin to remove users/images
    }

    modifier onlyAdmin() {
        if (msg.sender != GreektAdmin)
            throw;
        _; // Never forgot _;, will be replaced by function when modifier is used
    }

    function removeUser(address badUser) onlyAdmin returns (bool success) {
        delete Users[badUser];
        return true;
    }

    function removeImage(bytes32 badImage) onlyAdmin returns (bool success) {
        delete notarizedImages[badImage];
        return true;
    }

    function registerNewUser(string handle, bytes32 city, bytes32 county, bytes32 country) return (bool success) {
        address thisNewAddress = msg.sender;

        if (bytes(Users[msg.sender].handle).length == 0 && bytes(handle).length != 0) {
                                                            // make sure handle isn't null and not existing already
            Users[thisNewAddress].handle = handle;
            Users
        }

    }
}