

Here I documented all the API's I tested and the result will be in the json file named as result:*  bellow


Note: For all POST request we need to add this Auth:
 Authorization: Barear eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZmMzZWFkYTYtNDdhZS00NzRlLThjN2ItMGE3OWUxMDdlYWQyIiwiYXVkIjpbImZhc3RhcGktdXNlcnM6YXV0aCIsImZhc3RhcGktdXNlcnM6dmVyaWZ5Il19.IEZRCKZBFa_iHf5tT1loxY5t52NgIrwBg85eyxOyuqw

**Block API**
<br>
1.***getting the latest block***
    End Point :https://api.quantor.me/v1/eth/block/meta/latest_block?require_active=true
    <br>
    Method : POST
    <br>
    result:recentBlock.json

**CONTRACT_API**
<br>
1. ***getting the price of a token /tokens***
    1. **with time rage**
    End Point : https://api.quantor.me/v1/eth/contract/erc20/prices/time_range?contract_address=0xC18360217D8F7AB5E7C516566761EA12CE7F9D72&limit=10000&after=1&before=1660820292449&granularity=day
    <br>
    Method : POST
    <br>
    result:priceBlock.json


    1. **with_blockNumber**
       End Point : https://api.quantor.me/v1/eth/contract/erc20/prices/addresses_and_block?currency=usd&block_number=15408567&limit=10
       <br>
       Method : POST
       <br>
       body:`{
              "addresses": [
                "0xC18360217D8F7AB5E7C516566761EA12CE7F9D72",
                "0xdAC17F958D2ee523a2206206994597C13D831ec7"
              ]
            }`
       <br>
       result:priceRage.json





**WALLET_API**

***1. getting all tokens of wallet***
<br>
 Ex: getting tokens of vitalik.eth wallet
 End Point: https://api.quantor.me/v1/eth/wallet/erc20/pnl/by_token?wallet_address=0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045&currency=usd&require_active=true
 <br>
result:walletTokens.json








