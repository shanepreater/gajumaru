# 🌳 Gajumaru Linux Setup

Welcome to the **Gajumaru** repository – your hub for onboarding and development help related to the Gaju project.

## 🚀 Getting Started
### The Simple Option - Debian based systems like Ubuntu, Kali, Mint etc
1. run `wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/quick-start-deb.sh  && bash quick-start-deb.sh`

That is all!
### The Simple Option - RPM based systems like RHEL, Rocky, Fedora etc
1. run `wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/quick-start-rpm.sh  && bash quick-start-rpm.sh`

That is all!

### The More involved option
In order to set everything up you will need to run the following scripts:
1. `sudo ./setup-erlang.sh`
2. `./setup-gaju.sh`
3. *POST REBOOT* `./setup-scripts.sh`

## 🖥️ Desktop Shortcuts

After completing setup, you should see two desktop links:

    💼 Gaju Desktop – The desktop wallet application

    ⛏️ Gaju Miner – The mining application

    ⚠️  Note: You may need to right-click each desktop icon and select Allow Launching to enable them.

Prior to being able to use these you will need to right click and click "Allow Launching". This will allow it to launch the scripts.
![Context menu](images/context-menu.png?raw=true "Context menu")

Initially the desktop icons will look like this: ![Desktop icon pre-enabling](images/icon-with-cross.png?raw=true "Cleanly installed icon")
If you try to run before enabling you will get an error like this: ![Launch error](images/launch-fail.png?raw=true "Launcher failure")


Happy mining! 🌐✨

# Headless mining
You can also setup the system to perform headless mining (The mining service has no UI components so runs totally in the background)

This is a more advanced version so if you have any doubts, simply use the GajuMining shortcut.

## Setup
1. You need to have created your mining account (and associated wallet)
2. You need to have your public key (Account Id) to hand
3. run `wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/setup-headless-mining.sh  && bash setup-headless-mining.sh <PUBKEY> <MINERS>` - Where PUBKEY is your public key and MINERS is the number of concurrent miners to run (probably stick to 1 or 2).

As part of the initial install, you will have "cloned" (I.E. downloaded) the gajumaru scripts repository. typically this is in ~/gajumaru.
You can find the setup-headless-miner.sh script there as well.

## Post install
Everytime the system is rebooted, it will automatically launch the headless miner system.

## Modifying the configuration
The headless miner uses a configuration file to control the concurrent miners etc. This can be found in `/usr/local/gajuminer/gmhive_client_config.json`

### Modifying the miners
If you edit that `gmhive_client_config.json` file you will see a section like this:
<code>
  "workers": [
    {"executable": "mean29-avx2"}
    ,{"executable": "mean29-avx2"}
  ]
</code>

You can add additional (or fewer) `,{"executable": "mean29-avx2}` lines to the file. 

Also you can change the worker which is mining the Gajus to be one of:
* mean29-generic - Less optimised mean miner (Massively CPU and Memory intensive, typically consumes 3Gb memory per worker)
* mean29-avx2 - More optimised mean miner (Massively CPU and Memory intensive, typically consumes 3Gb memory per worker)
* lean29-generic - Less optimised lean miner (Less Memory intensive, typically consumes 1Gb memory per worker)
* lean29-avx2 - More optimised lean miner (Less Memory intensive, typically consumes 1Gb memory per worker)
* cuda29 - GPU worker **NOTE:** This is an advanced worker and requires additional drivers etc specific to your device.
