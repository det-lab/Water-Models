# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import netCDF4 as nc
fn = "water_mdcrd.nc"
ds = nc.Dataset(fn)
print (ds)
coordinates = ds['coordinates']
print (coordinates[0,0,:])
print (coordinates[1,0,:])
