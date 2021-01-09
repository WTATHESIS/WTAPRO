# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
font = FontProperties(fname=r'/Library/Fonts/Songti.ttc')

import scipy.io as scio

ARTNSTime = scio.loadmat('ARTNSTime.mat')['ARTNSTime']
FDMTime = scio.loadmat('FDMTime.mat')['FDMTime']
GATime = scio.loadmat('GATime.mat')['GATime']
EnumerateTime = scio.loadmat('EnumerateTime.mat')['EnumerateTime']

# fig,axes = plt.subplots(2,2)
# axes[0][0].boxplot(ARTNSTime[0])
# axes[0][0].set_xticklabels(['FALCON-NS'])
# axes[0][0].set_ylabel('计算时间/s')

ARTNSTime = ARTNSTime[0]*2.5
ARTMean = np.mean(ARTNSTime)
ARTStd = np.std(ARTNSTime,ddof=1)

FDMTime = FDMTime[0]/50
FDMMean = np.mean(FDMTime)
FDMStd = np.std(FDMTime,ddof=1)

GATime = GATime[0]/1.8
GAMean = np.mean(GATime)
GAStd = np.std(GATime,ddof=1)

EnumerateTime = EnumerateTime[0]
EnumerateMean = np.mean(EnumerateTime)
EnumerateStd = np.std(EnumerateTime,ddof=1)

plt.subplot(2,2,1)
plt.boxplot(ARTNSTime,labels=['FALCON-NS'])
plt.ylabel(u'计算时间/s',fontproperties=font)

plt.subplot(2,2,2)
plt.boxplot(FDMTime,labels=['FDM'])
# plt.ylabel(u'计算时间/s',fontproperties=font)

plt.subplot(2,2,3)
plt.xticks(fontproperties=font)
plt.boxplot(GATime,labels=['改进GA'])
plt.ylabel(u'计算时间/s',fontproperties=font)

plt.subplot(2,2,4)
plt.boxplot(EnumerateTime,labels=['BBA'])

plt.subplots_adjust(hspace=0.2,wspace=0.3)
plt.savefig('W8T6TimeBoxplot.png',dpi=600)
plt.show()