import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const factory = new web3.eth.Contract(
  CampaignFactory.abi,
  '0x66E9050DC67dD603E018E4786f2870d293608bdd'
);

export default factory;
