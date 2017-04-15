pragma solidity ^0.4.6;


contract Owned {
    
    address public owner;
    
    function Owned() { owner = msg.sender; }
    
}


contract Mortal is Owned {
    
    function kill() { if (msg.sender == owner) selfdestruct(owner); }
}


contract Minion {
		
		string public minionName;
		address public personaAddress;
		address public owner;

		mapping(address=>AuthorizedList) public list;

		struct AuthorizedList{
			bool active;
			address addressAuthorized;
		}
		
		event Paid(uint256);
		event Balance(uint256);
        uint256 total;
        
        modifier onlyAuthorized {
	        if (!list[msg.sender].active) throw;
	        _;
	    }
        
        modifier onlyPersona {
	        if (msg.sender != personaAddress) throw;
	        _;
	    }
        
        function () payable {
            total += msg.value;
            Paid(msg.value);
            Balance(this.balance);
        }

		function Minion(string _name, address _personaAddress){
			minionName = _name;
			personaAddress = _personaAddress;
			owner = msg.sender;
			list[_personaAddress] = AuthorizedList({
					active : true,
					addressAuthorized : owner
					});
		}
		
		function getOwner() returns (address minionOwner){
		    return owner;
		}

		function requestEther(uint256 _amount) onlyAuthorized{
			Persona personaOrigin = Persona(personaAddress);
			personaOrigin.requestEther(_amount);
		}

		function destroy() onlyPersona {
		    selfdestruct(owner);
		}

		function sendEther(uint256 _amount, address _destinationAddress) onlyAuthorized {
			_destinationAddress.call.gas(5000000).value(_amount)();
		}

		function setList(address _addAddress) onlyPersona {
				list[_addAddress] = AuthorizedList({
					active : true,
					addressAuthorized : _addAddress
					});
		}

}


contract Persona is Mortal{
		
		string public personaName;
		address public personaAddress;
		Minion public DefaultMinion;

		mapping(address=>minionStruct) public labels;

		struct minionStruct{
			bool active;
			uint256 amount;
		}
		
		event Paid(uint256);
		event Balance(uint256);

		function Persona(string _name){
			personaName = _name;
			personaAddress = this;
			DefaultMinion = new Minion("DefaultMinion", this);
			DefaultMinion.setList(owner);
		}
		
	
        function () payable {
            Paid(msg.value);
            Balance(this.balance);
        }

		function setList(address _addAddress, address _minionAddress){
			if (labels[_minionAddress].active){
			    Minion newMinion = Minion(_minionAddress);
			    newMinion.setList(_addAddress);
				}else{
					throw;
				}
		}
		
		function controlMinion(address _minionAddress){
			labels[_minionAddress] = minionStruct({
				active : true,
				amount : 0
			});
			Minion newMinion = Minion(_minionAddress);
			//newMinion.setList(personaAddress);
			newMinion.setList(newMinion.getOwner());
		}

		function requestEther(uint256 _amount){
			if (labels[msg.sender].active){
				labels[msg.sender].amount = _amount;
			}else{
				throw;
			}
		}

		function sendEther(address _minionAddress) payable {
		    _minionAddress.call.gas(5000000).value(labels[_minionAddress].amount)();
		    Paid(msg.value);
			Balance(this.balance);
		}

		function destroyMinion(address _minionAddress){
			if (labels[_minionAddress].amount == 0){
				labels[_minionAddress].active = false;
				Minion minionInactive = Minion(_minionAddress);
				minionInactive.destroy();
			}
		}

}
