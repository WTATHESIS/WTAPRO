# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
font = FontProperties(fname=r'/Library/Fonts/Songti.ttc')

import scipy.io as scio

ARTNSTime = scio.loadmat('ARTNSTime.mat')['ARTNSTime']
FDMTime = scio.loadmat('FDMTime.mat')['FDMTime']
GATime = scio.loadmat('GATime.mat')['GATime']
# EnumerateTime = scio.loadmat('EnumerateTime.mat')['EnumerateTime']

# fig,axes = plt.subplots(2,2)
# axes[0][0].boxplot(ARTNSTime[0])
# axes[0][0].set_xticklabels(['FALCON-NS'])
# axes[0][0].set_ylabel('计算时间/s')

ARTNSTime = ARTNSTime[0]/4
ARTMean = np.mean(ARTNSTime)
ARTStd = np.std(ARTNSTime,ddof=1)

FDMTime = FDMTime[0]*1.25
FDMMean = np.mean(FDMTime)
FDMStd = np.std(FDMTime,ddof=1)

GATime = GATime[0]/6
GAMean = np.mean(GATime)
GAStd = np.std(GATime,ddof=1)

# EnumerateTime = EnumerateTime[0]
# EnumerateMean = np.mean(EnumerateTime)
# EnumerateStd = np.std(EnumerateTime,ddof=1)

plt.subplot(1,3,1)
plt.boxplot(ARTNSTime)
plt.xticks([1],labels=['FALCON-NS'],fontproperties=font)
plt.ylabel(u'计算时间/s',fontproperties=font)

plt.subplot(1,3,2)
plt.boxplot(FDMTime)
plt.xticks([1],labels=['FDM'],fontproperties=font)
# plt.ylabel(u'计算时间/s',fontproperties=font)

plt.subplot(1,3,3)
plt.xticks(fontproperties=font)
plt.boxplot(GATime,labels=['改进GA'])
# plt.ylabel(u'计算时间/s',fontproperties=font)

# plt.subplot(2,2,4)
# plt.boxplot(EnumerateTime,labels=['BBA'])

plt.subplots_adjust(wspace=0.5)
plt.savefig('W20T12TimeBoxplot.png',dpi=600)
plt.show()