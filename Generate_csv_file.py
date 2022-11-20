# Import Packages
import rasterio
import os
import numpy as np
import pandas as pd

table = pd.DataFrame(0,index = np.arrange(1,2022),columns = ['Data','Temp'])
i = 0

for files in os.listdir(r'c:'):
  if files[-4:] == '.tif':
    i = i + 1
    dataset = rasterio.open(r'c:'+'\\'+files)
    x,y = ()
    row, col = dataset.index(x,y)
    data_array = dataset.read(1)
    
    
# Copy the date to the "Date" column in the table during each iteration.

table['Date'].loc[i] = files[:-4]

# Fill in the climatee Values

table['Temp'].loc[i] = data_array[int(row),int(col)]

# Export the table into a csv file

table.to_csv(r'c:\ name.csv')

