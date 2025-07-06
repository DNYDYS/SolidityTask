// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

//   用 solidity 实现整数转罗马数字
// 题目描述在 https://leetcode.cn/problems/roman-to-integer/description/3.
contract IntToRoman{
    mapping (uint256 => string) private  romanSymbols;
    constructor(){
        romanSymbols[1] = "I";
        romanSymbols[4] = "IV";
        romanSymbols[5] = "V";
        romanSymbols[9] = "IX";
        romanSymbols[10] = "X";
        romanSymbols[40] = "XL";
        romanSymbols[50] = "L";
        romanSymbols[90] = "XC";
        romanSymbols[100] = "C";
        romanSymbols[400] = "CD";
        romanSymbols[500] = "D";
        romanSymbols[900] = "CM";
        romanSymbols[1000] = "M";
    }

    uint256[] private n = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];

    function convert(uint256 num) public view returns (string memory){
        string memory result = "";
        for (uint i = 0; i< n.length ; i++)
        {
            while (num >= n[i])
            {
                result = string(abi.encodePacked(result, romanSymbols[n[i]]));
                num -= n[i];
            }
        }
        return result;
      }

}