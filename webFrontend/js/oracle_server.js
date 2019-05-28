App = {
    web3Provider: null,
    contracts: {},
    account: '0x0'
}

const start = () => {
    initWeb3()
    .then(updateCandidates)
    .then(restart)
    .catch(error);
};

function initWeb3(){
    if (typeof web3 !== 'undefined') {
        // If a web3 instance is already provided by Meta Mask.
        App.web3Provider = web3.currentProvider;
        web3 = new Web3(web3.currentProvider);
    } else {
        // Specify default instance if no web3 instance provided
        console.log("no metamask");
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
        web3 = new Web3(App.web3Provider);
    }
      
    $.getJSON("Election.json", function(election) {
        // Instantiate a new truffle contract from the artifact
        App.contracts.Election = TruffleContract(election);
        // Connect provider to interact with contract
        App.contracts.Election.setProvider(App.web3Provider);
      
        App.listenForEvents();
    });

    // Load account data
    web3.eth.getCoinbase(function(err, account) {
        if (err === null) {
          App.account = account;
        }
    });
}

function updateCandidates(){
    App.contracts.Election.deployed().then(function(instance) {
        electionInstance = instance;
        console.log(instance);
    });

    electionInstance.reqCandidate().watch(function(error, result){
        if (!error)
            {
                electionInstance.addCandidate("Peter");
                electionInstance.addCandidate("Wurst");
            } else {
                $("#loader").hide();
                console.log(error);
            }
    });
}

const restart = () => {
    wait(process.env.TIMEOUT).then(start);
};