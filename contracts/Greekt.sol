pragma solidity ^0.4.4;

// Simple solidity demo contract for learning - Connor
// https://github.com/Tectract/ethereum-demo-tools/blob/master/GeektSolidity/contracts/Geekt.sol
// https://blockgeeks.com/guides/how-to-learn-solidity/

contract Greekt {
    address GreektAdmin;

    mapping ( bytes32 => notarizedImage) notarizedImages;   // will allow a user to look up their image by 
                                                            // their SHA256notaryHash
    bytes32[] imagesByNotaryHash;                           // phonebook of all images, by SHA256notaryHash

    mapping (address => User) Users;                        // allows the lookup of users by ethereum address, our main storage object 
    address[] usersByAddress;                               // phonebook of users, by address

    struct notarizedImage {                                 // These cost ether to make and change!
        string imageURL;
        uint timeStamp;
    }

    struct User {                                           // These cost ether to make and change!
        string handle;
        bytes32 city;
        bytes32 county;
        bytes32 country;
        bytes32[] myImages;
    }

    function Greekt() payable {                             // Constructor, called once when contract deployed
        GreektAdmin = msg.sender;                           // Making an admin to remove users/images
    }

    modifier onlyAdmin() {
        if (msg.sender != GreektAdmin)
            throw;
        _;                                                  // Never forget _;, will be replaced by function when modifier is used
    }

    function removeUser(address badUser) onlyAdmin returns (bool success) {
        delete Users[badUser];
        return true;
    }

    function removeImage(bytes32 badImage) onlyAdmin returns (bool success) {
        delete notarizedImages[badImage];
        return true;
    }

    function registerNewUser(string handle, bytes32 city, bytes32 county, bytes32 country) returns (bool success) {
        address thisNewAddress = msg.sender;

        if (bytes(Users[msg.sender].handle).length == 0 && bytes(handle).length != 0) {
                                                            // make sure handle isn't null and not existing already
            Users[thisNewAddress].handle = handle;
            Users[thisNewAddress].city = city;
            Users[thisNewAddress].county = county;
            Users[thisNewAddress].country = country;
            usersByAddress.push(thisNewAddress);            // adds the entry for the user to the phonebook
            return true;
        } else {
            return false;                                   // either empty user, or user already exists
        }

    }

    function addImageToUser(string imageURL, bytes32 SHA256notaryHash) returns (bool success) {
        address thisNewAddress = msg.sender;
        if(bytes(Users[thisNewAddress].handle).length != 0){ // make sure this user has created an account first
            if(bytes(imageURL).length != 0){   // ) {  // couldn't get bytes32 null check to work, oh well!
                // prevent users from fighting over sha->image listings in the whitepages, but still allow them to add a personal ref to any sha
                if(bytes(notarizedImages[SHA256notaryHash].imageURL).length == 0) {
                    imagesByNotaryHash.push(SHA256notaryHash); // adds entry for this image to our image whitepages
                }
                notarizedImages[SHA256notaryHash].imageURL = imageURL;
                notarizedImages[SHA256notaryHash].timeStamp = block.timestamp; // note that updating an image also updates the timestamp
                Users[thisNewAddress].myImages.push(SHA256notaryHash); // add the image hash to this users .myImages array
                return true;
            } else {
                return false; // either imageURL or SHA256notaryHash was null, couldn't store image
            }
            return true;
        } else {
            return false; // user didn't have an account yet, couldn't store image
        }
    }

    function getUsers() constant returns (address[]) {return usersByAddress; } //constant data is free to read

    function getUser(address userAddress) constant returns (string,bytes32,bytes32,bytes32,bytes32[]) {
        return (Users[userAddress].handle,Users[userAddress].city,Users[userAddress].county, Users[userAddress].country,Users[userAddress].myImages);
    }

    function getUserImages(address userAddress) constant returns (bytes32[]) {return Users[userAddress].myImages; }

    function getImage(bytes32 SHA256notaryHash) constant returns (string,uint) {
        return (notarizedImages[SHA256notaryHash].imageURL,notarizedImages[SHA256notaryHash].timeStamp);
    }

}