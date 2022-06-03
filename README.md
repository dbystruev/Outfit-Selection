# Outfit-Selection
GetOufit.ru Selection Prototype

## Installation

Install via TestFlight: [testflight.apple.com/join/xNvAtbhx](https://testflight.apple.com/join/xNvAtbhx).

Make sure [TestFlight App](https://apps.apple.com/app/testflight/id899247664) is installed.

## Design

Figma [original](https://www.figma.com/file/R1u7CpopH9Kfj79P9Aseh0/Get-Outfit?node-id=0%3A1) and [updated](https://www.figma.com/file/YCL7qd5B147CPSPEqaVIMj/GetOutfit-%28Copy%29?node-id=1231%3A3502).

## View Controllers

![View Controllers](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/get_outfit_app.png)

## Individual Screenshots

![Logo](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot01.png?raw=true)
![Gender Selection](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot02.png?raw=true)
![Brand Selection](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot03.png?raw=true)
![Occasion Selection](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot04.png?raw=true)
![Picking Up Items](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot05.png?raw=true)
![Outfit Tab](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot06.png?raw=true)
![Feed Tab](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot07.png?raw=true)
![Feed Items](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot08.png?raw=true)
![Item Detail](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot09.png?raw=true)
![Wishlist Items](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot10.png?raw=true)
![Add to Occasions](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot11.png?raw=true)
![Wishlist Outfits](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot12.png?raw=true)
![Name Collection](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot13.png?raw=true)
![Choose Collection Items](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot14.png?raw=true)
![List Collections](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot15.png?raw=true)
![Profile Tab](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Resources/Screenshots/Screenshot16.png?raw=true)

## Requirements

REST/JSON server with the following API calls implemented with [PostgREST](https://postgrest.org):
* [categories](http://oracle.getoutfit.net:3000/categories)
* [items](http://oracle.getoutfit.net:3000/items?limit=10)
* [occasions](http://oracle.getoutfit.net:3000/occasions)
* [onboarding](http://oracle.getoutfit.net:3000/onboarding)
* [server](http://oracle.getoutfit.net:3000/server)

Example request:

[/items?gender=in.(male,unisex)&limit=45&order=modified_time.desc&vendor=in.(acoldwall,acnestudios)](http://oracle.getoutfit.net:3000/items?gender=in.%28male,unisex%29&limit=45&order=modified_time.desc&vendor=in.%28acoldwall,acnestudios%29)

## Acknowledgments

Get Outfit [Team](https://www.getoutfit.ru/aboutus) for invaluable contributions.

[PostgREST](https://postgrest.org) for great REST API for PostgreSQL database.

Icons by [Freepik](https://www.freepik.com) from [Flaticon](https://www.flaticon.com):
* [Clothes](https://www.flaticon.com/free-icon/clothes_130302)
* [Like](https://www.flaticon.com/premium-icon/like_2031035)
* [Like Filled](https://www.flaticon.com/premium-icon/like_2030957)
* [Shuffle](https://www.flaticon.com/free-icon/shuffle_359936)
* [Speech Bubble](https://www.flaticon.com/free-icon/speech-bubble_2462719)

Noto Sans [font](https://fonts.google.com/specimen/Noto+Sans) designed by Google.
