import Web3 from "web3";

let web3;

if(typeof window !== 'undefined' && typeof window.ethereum !== 'undefined'){
  // we are in the browser and metamask is running
  window.ethereum.request({ method: "eth_requestAccounts" });
  web3 = new Web3(window.ethereum);
} else{
  // we are in the server *OR* matamask is not running
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/v3/5eb4a135fb474b97932a04c38720d074'
  );
  web3 = new Web3(provider);
}

export default web3;
