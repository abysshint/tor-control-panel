<a name="readme-top"></a>
<div align="center">

[![Contributors](https://img.shields.io/github/contributors/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/network/members)
[![MIT License](https://img.shields.io/github/license/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/blob/main/LICENSE)
[![Stargazers](https://img.shields.io/github/stars/abysshint/tor-control-panel.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/stargazers)
[![Downloads](https://img.shields.io/github/downloads/abysshint/tor-control-panel/total.svg?style=for-the-badge)](https://github.com/abysshint/tor-control-panel/releases)

</div>

<div align="center">
  <a href="https://github.com/abysshint/tor-control-panel"><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/common/tcp-logo.png" alt="Logo" width="80" height="80"></a>
  <h3 align="center">Tor Control Panel</h3>
  <p align="center">
    Windows GUI Client for Tor Expert Bundle
    <br />
    <br />
    Language: 
	  <a href="https://github.com/abysshint/tor-control-panel#readme-top">English</a> · 
      <a href="https://github.com/abysshint/tor-control-panel/blob/main/README.ru.md#readme-top">Русский</a>
  </p>
</div>

## Table of contents

* [Overview](#overview)
* [System Requirements](#system-requirements)
* [Program Features](#program-features)
* [Screenshots](#screenshots)
* [Project Build](#Project-build)
* [Privacy](#privacy)
* [License](#license)
* [Links](#links)

## Overview
<u>Tor Control Panel</u> is a free and simple GUI tool for configuring, managing and monitoring the operation of the [Tor Expert Bundle](https://www.torproject.org/download/tor/) on the operating system Windows. The program's operation is based solely on editing configuration files, parsing local descriptor caches, and sending requests/receiving responses through the control port. The program has a nice and intuitive interface that will help you get more out of the Tor network with a minimum of effort.

## System Requirements
* Operating system: Windows 7 and above
* Tor version: 0.4.0.5 and above

    > Note: The program can run on Windows XP and Vista, but the latest supported version of Tor for these operating systems is 0.4.4.6, and pluggable transports need to be rebuilt in Golang version 1.10 and below.
<p align="right">[<a href="#readme-top">↑ Up</a>]</p>

## Program Features
* Ability to connect to the Tor network via bridges and a proxy server
* Ability to choose as nodes not only countries, but also hashes, IP addresses and CIDR masks
* Ability to reset Guard nodes
* Ability to scan relays for reachability of ports and ping measuring
* Ability to manage hidden services
* Ability to use selected Entry nodes as Vanguards
* Ability to add and configure the launch of pluggable transports
* Saving/Loading your lists of Entry, Middle, Exit and Exlude nodes
* Automatic nodes selection based on user settings
* Running multiple copies of the program with different profiles
* Showing the Tor message log and saving it to a file
* Configuring Tor to Work in Server Mode (Exit Node, Relay, and Bridge)
* View information on all nodes of the current consensus (Nickname, IP address, Country, Version, Consensus weight, Ping, etc.)
* A convenient filtering, searching and sorting system that helps you choose the most suitable nodes
* Viewing and closing circuits/active connections
* Displaying traffic statistics in the form of a graph and digital data
* The program is portable, installation is not required, where it was launched, it works there
* Support for visual themes
* Multilingual interface with the ability to add new localizations
<p align="right">[<a href="#readme-top">↑ Up</a>]</p>

## Screenshots
<table border="0">
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-general.png" alt="tcp-options-general"></td>	
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-network.png" alt="tcp-options-network"></td>  
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-filter.png" alt="tcp-options-filter"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-server.png" alt="tcp-options-server"></td>	
  </tr>
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-circuits.png" alt="tcp-circuits"></td>
    <td colspan="2"><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-status.png" alt="tcp-status"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-relays.png" alt="tcp-relays"></td>
  </tr>
  <tr align="center">
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-hs.png" alt="tcp-options-hs"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-lists.png" alt="tcp-options-lists"></td>
    <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-options-other.png" alt="tcp-options-other"></td>
     <td><img src="https://raw.githubusercontent.com/abysshint/tor-control-panel/main/images/english/tcp-log.png" alt="tcp-log"></td>	
  </tr>
</table>
<p align="right">[<a href="#readme-top">↑ Up</a>]</p>

## Project Build
1. Install the IDE [Delphi 10.4.2 CE](https://www.embarcadero.com/ru/products/delphi/starter/free-download)
    > Warning! Building the project in other versions of Delphi has not been tested and may lead to the most unexpected results.
2. Download and install the Delphi library [Ararat Synapse](https://sourceforge.net/p/synalist/code/HEAD/tree/trunk/)

    * Create a folder **Synapse** and extract the files from the archive **synalist-code-r000-trunk.zip** into it
	
      `C:\Program Files (x86)\Embarcadero\Studio\21.0\source\Synapse`
	  
    * Open the Delphi Options and add the path **$(BDS)\source\Synapse** to the lists **Library path** and **Browsing path**
	
      `[Tools] → [Options] → [Language] → [Delphi] → [Library] → [Windows 32-bit]/[Windows 64-bit]`
	  
3. Open the file **TorControlPanel.dproj**, select platform and compile the project by pressing the **[Run]** button
4. Run the file **TCP-RSP-31045-PATCHER.exe** to fix the Delphi 10.4 bug which causes the buttons to be displayed incorrectly in Windows 7 when Aero is enabled.
    > Warning! The [AT4RE-Patcher-v0.7.6](https://github.com/anomous/AT4RE-Patcher-Windows) program was used to create the patch. The patches created in it are defined by some antiviruses as potentially dangerous applications, since "hacker" methods of modifying executable files are used.
<p align="right">[<a href="#readme-top">↑ Up</a>]</p>

## Privacy
The program does not have direct access to the transmitted user data, does not require administrator rights, does not change any operating system system settings, including the system proxy server, does not collect any usage statistics

## License
This program is free software and distributed under the [MIT license](https://github.com/abysshint/tor-control-panel/blob/main/LICENSE)

## Links
* [Tor Manual](https://man.archlinux.org/man/tor.1)
* [Tor Specifications and Proposals](https://gitlab.torproject.org/tpo/core/torspec)
* [Tor Project Distribution Server](https://dist.torproject.org/)
* [Tor Project File Archive](https://archive.torproject.org/tor-package-archive/)
* [Fresh GeoIP databases](https://gitlab.torproject.org/tpo/network-health/metrics/geoip-data/-/packages)
<p align="right">[<a href="#readme-top">↑ Up</a>]</p>
