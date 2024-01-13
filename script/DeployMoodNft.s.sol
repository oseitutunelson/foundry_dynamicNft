//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from 'forge-std/Script.sol';
import {MoodNft} from '../src/MoodNft.sol';
import {Base64} from '@openzeppelin/contracts/utils/Base64.sol';

contract DeployMoodNft is Script{
    function run() external returns (MoodNft){
      string memory sadSvg = vm.readFile('./img/sad.svg');
      string memory happySvg = vm.readFile('./img/happy.svg');

      vm.startBroadcast();
      MoodNft moonnft = new MoodNft(
        svgToImageUri(sadSvg),
        svgToImageUri(happySvg)
      );
      vm.stopBroadcast();
      return moonnft;
    }

    //convert svg to image uri
    function svgToImageUri(string memory svg) public pure returns (string memory){
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgEncoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseURL,svgEncoded));
    }
}