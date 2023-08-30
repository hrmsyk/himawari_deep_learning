#!/usr/bin/env python

import glob
import cv2
import pandas as pd

filename_list = glob.glob("/home/hara/git/himawari_deep_learning/data/2023/08/01/*.jpg")
#print(files)

df = pd.DataFrame()
for filename in filename_list:
    img = cv2.imread(filename)
    img_series = pd.Series(img.flatten())
    print(type(img_series))
    print(img_series)
    dftmp = pd.DataFrame({filename:img_series})
    df = pd.concat([df,dftmp])
#    img_gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
#    print(pd.Series(img_gray.flatten()))
#    df = df.append(pd.Series(img_gray.flatten()), ignore_index=True)
print(df)

df.to_csv('out.txt', header=False, index=False, sep=' ')
