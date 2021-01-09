import numpy as np
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
font = FontProperties(fname=r'/Library/Fonts/Songti.ttc')

rawfitness = np.load('rawfitness.npy')
virtualfitness = np.load('virtualsolutionfitness.npy')
classicfitness = np.load('classicsolutionfitness.npy')
optfitness = np.min(virtualfitness)*np.ones((1,100))

a = min(virtualfitness[0])
print(a)

rawm=np.mean(rawfitness-optfitness)
raws = np.std(rawfitness-optfitness)
virtualm = np.mean(virtualfitness-optfitness)
virtuals = np.std(virtualfitness-optfitness)
classicm = np.mean(classicfitness - optfitness)
classics = np.std(classicfitness-optfitness)
print(rawm,raws,virtualm,virtuals,classicm,classics)

fig, ax = plt.subplots()
plt.plot(rawfitness[0,:],'--', color = 'k',label='FALCON算法')
plt.plot(classicfitness[0,:],'-',color='k',label='未引入虚拟武器节点的FALCON-NS')
plt.plot(virtualfitness[0,:],'.-',color = 'k',label='引入虚拟武器节点的FALCON-NS')

# plt.ylabel('适应度均值',fontproperties=font)
# plt.xlabel('训练集容量',fontproperties=font)
plt.ylabel(u'最优解适应度', fontproperties=font)
plt.xlabel(u'测试集算例索引', fontproperties=font)

plt.legend(prop=font)
plt.savefig('VirtualNodeCompare.png',dpi=600)
plt.show()

# temp = 4 * np.ones((1,100))
# virtualtime = virtualtime - temp
# tempdata = np.hstack((classictime.T,virtualtime.T))
# fig,ax = plt.subplots()
# ax.boxplot(tempdata)
# ax.set_xticklabels(['non-virtual node','virtual node'])
# fig.savefig('VirtualTimeCompare.png',dpi=300)
# fig.show()
