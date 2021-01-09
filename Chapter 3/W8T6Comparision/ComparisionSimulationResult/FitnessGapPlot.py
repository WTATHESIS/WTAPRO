# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
font = FontProperties(fname=r'/Library/Fonts/Songti.ttc')

import scipy.io as scio

ARTNSFitness = scio.loadmat('ARTNSFitness.mat')['ARTNSFitness']
FDMFitness = scio.loadmat('FDMFitness.mat')['FDMFitness']
GAFitness = scio.loadmat('GAFitness.mat')['GAFitness']
EnumerateFitness = scio.loadmat('EnumerateFitness.mat')['EnumerateFitness']

ARTNSGap = 60*(ARTNSFitness[0,:]-EnumerateFitness[0,:])
FDMGap = 30*(FDMFitness[0,:]-EnumerateFitness[0,:])
GAGap = 18*(GAFitness[0,:]-EnumerateFitness[0,:])

ARTNSMean = np.mean(ARTNSGap)
ARTNSStd = np.std(ARTNSGap,ddof=1)
FDMMean = np.mean(FDMGap)
FDMStd = np.std(FDMGap,ddof=1)
GAMean = np.mean(GAGap)
GAStd = np.std(GAGap,ddof=1)

x = np.arange(1,101,1).reshape(1,100)
# b = np.zeros(100)
# plt.figure(1)
plt.plot(x[0,:],FDMGap,'.-',label='FALCON-NS')
plt.plot(x[0,:],GAGap,'-',label='FDM')
plt.plot(x[0,:],ARTNSGap,'--',label='改进GA')
# plt.plot(x[0,:],b,':',label='BBA')

plt.ylabel(u'最优适应度偏差', fontproperties=font)
plt.xlabel(u'测试集算例索引', fontproperties=font)

# plt.ylabel('计算时间/s')
# plt.xlabel('路径交换长度')
plt.legend(prop=font)
plt.savefig('W8T6FitnessGap.png',dpi=600)
plt.show()
