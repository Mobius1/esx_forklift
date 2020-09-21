# esx_forklift
Forklift job for FiveM

**NOTE: This resource is still under active development. While it works almost perfectly, there may be unreported bugs.**

## Features
* Pickup and deliver pallets
* Earnings per-pallet delivered
* Fines for damaged goods
* Add your own pickup / delivery points

## Requirements

* [es_extended](https://github.com/ESX-Org/es_extended)

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/esx_forklift/archive/master.zip
* Rename the `esx_forklift-master` directory to `esx_forklift`
* Drop the `esx_forklift` directory into the `[esx]` directory on your server
* Import `esx_forklift.sql` into to your database
* Add `start esx_forklift` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Adding Collection / Delivery Points
* Open `config.lua` and add your custom points to `Config.Points`
```lua
Config.Points = 
    { Pos = vector3(-366.03740, -2784.58300, 5.00000), Heading = 90.00 }, 
    ...
}
```

## Using Custom Vehicles
To use a custom vehicle just open `config.lua` and edit `Config.Vehicle` and enter the spawn code:

```lua
    Config.Vehicle = 'spawn_code_here'
```

I recommend [DIBZER's Forklift](https://forum.cfx.re/t/dibzers-hvy-forklift-non-els-add-on/848865) for this job. Make sure you give him some love!

## Development Options
Setting `Config.Debug` to `true` renders blips to show the location of all points and renders some debug text to the screen to help with development. The package is written to allow it to be restarted properly with `restart esx_forklift` in the console.

## Videos

* Coming soon...

## Contributing
Pull requests welcome.

## Legal

### License

esx_forklift - Forklift job for FiveM

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
