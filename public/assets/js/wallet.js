const walletButton = document.querySelector('#walletButton');
const showAccount = document.querySelector('#showAccount')


if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
  }

if (window.ethereum.isConnected){
    console.log(window.ethereum.isConnected);
    showAccount.innerHTML = "You are connected";
}

walletButton.onclick = function(){
    console.log('you clicked');
    getAccount();
};

async function getAccount() {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    const account = accounts[0];
    showAccount.innerHTML = "You are connected";
    $(`[data-modal=connect_wallet]`).removeClass('active')
  }
